USE [DB]
GO
/****** Object:  StoredProcedure [temp].[ABTClientes_PredictCusters_PY]    Script Date: 27/8/2020 17:35:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [temp].[ABTClientes_PredictCusters_PY] (@model_name varchar(100))
AS
BEGIN
DECLARE @py_model varbinary(max) = (select model from [Analytics].[temp].[ABTClientesKmeansTrained] where model_name = @model_name);

EXECUTE sp_execute_external_script @language = N'Python'
    , @script = N'

import pandas as pd
import numpy as np
import pickle

from sklearn.cluster import KMeans

km = pickle.loads(py_model)

df = my_input_data

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

clusters = km.predict(df[variables_cluster])

df["cluster"] = clusters

clusters_dic = {
				6:1,
				2:2,
				1:3,
				4:4,
				5:5,
				0:6,
				7:7,
				3:8
				}

df["cluster"] = df["cluster"].map(clusters_dic)

df.reset_index(inplace=True, drop=True)

OutputDataSet = df[["id_cli_persona", "periodo", "cluster"]]

'

, @input_data_1 = N' SELECT * FROM [Analytics].[temp].[ABTClientesNorm]'
, @input_data_1_name = N'my_input_data'
, @params = N'@py_model varbinary(max)'
, @py_model = @py_model

WITH result SETS ((
	[id_cli_persona] int not null,
	[periodo] int not null,
	[cluster] int not null))

END
