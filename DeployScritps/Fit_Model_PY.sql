USE [DB]
GO
/****** Object:  StoredProcedure [temp].[ABTClientes_FIT_MODEL_PY]    Script Date: 27/8/2020 17:32:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [temp].[ABTClientes_FIT_MODEL_PY]

@trained_model varbinary(max) OUTPUT,
@examples int OUTPUT

AS

BEGIN
EXECUTE sp_execute_external_script 
	  @language = N'Python'
    , @script = N'

import pandas as pd
import numpy as np
import pickle
from sklearn.cluster import MiniBatchKMeans, KMeans

df = InputDataSet;

def z_transform(tabla, variables):
    for col in variables:
        tabla[col] = tabla[col].astype(float)
        tabla[col].values[tabla[col] <= 0] = np.NaN
        tabla[col] = tabla[col].apply(np.log)
        tabla[col] = (tabla[col] - tabla[col].mean()) / tabla[col].std()
        tabla[col].values[tabla[col] > 3] = 3
        tabla[col].values[tabla[col] < -3] = -3
        tabla[col].fillna(tabla[col].min(), inplace=True)
        tabla[col] = (tabla[col] - tabla[col].min()) / (tabla[col].max() - tabla[col].min())
    return tabla

normalizar = [
        "ctas_saldo_ars",
        "ctas_cred_total_ars",
        "inv_capital_ars",
        "txe_ctc_monto_ars",
        "txe_cant",
        "ctc_cant",
        "prestamos_personales_capintc",
        ]
    
df = z_transform(df,normalizar)
    
prods_cant_map = {
    0:0.00,
    1:0.25,
    2:0.50,
    3:0.75,
    4:1.00,
    5:1.00,
    6:1.00,
	}
    
df["prods_cant"] = df["prods_cant"].map(prods_cant_map)

variables_cluster = [
        "prods_cant",
        "hb_flag",
        "ope_tipo_operacion_SUELDO",
        "desc_segmento_PREVISIONAL",
        "pza_flag",       
        "ctas_saldo_ars",
        "ctas_cred_total_ars",
        "inv_capital_ars",
        "txe_cant",
        "ctc_cant",
        "txe_ctc_monto_ars",
        "prestamos_personales_capintc",
]

km_param = MiniBatchKMeans(init="k-means++",
						   max_iter=1000,
						   n_clusters=8,
						   n_init=10,
						   random_state=10,
						   tol=0.0001,
						   verbose=0,
						   batch_size=400)


# MemoryError
#km_param = KMeans(algorithm="auto", copy_x=True, init="k-means++", max_iter=300,
#				  n_clusters=8, n_init=10, n_jobs=-1, precompute_distances="auto",
#			      random_state=10, tol=0.0001, verbose=0)


km = km_param.fit(df[variables_cluster])

examples = len(df.index)
trained_model = pickle.dumps(km)

'
, @input_data_1 = N' 
	SELECT
	  [id_cli_persona]
      ,[periodo]
      ,[desc_segmento_PREVISIONAL]
      ,[per_flg_activo_de_4m]
      ,[txe_cant]
      ,[ctc_cant]
      ,[prods_cant]
      ,[hb_flag]
      ,[ope_tipo_operacion_SUELDO]
      ,[pza_flag]
      ,[ctas_saldo_ars]
      ,[ctas_cred_total_ars]
      ,[inv_capital_ars]
      ,[txe_ctc_monto_ars]
      ,[prestamos_personales_capintc]
  FROM [Analytics].[temp].[ABTClientesNorm]'

, @params = N'@trained_model varbinary(max) OUTPUT, @examples int OUTPUT'
, @trained_model = @trained_model OUTPUT
, @examples = @examples OUTPUT

END;
