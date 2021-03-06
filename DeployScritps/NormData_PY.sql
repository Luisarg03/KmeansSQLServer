USE [DB]
GO
/****** Object:  StoredProcedure [temp].[ABTClientes_NormData_PY]    Script Date: 27/8/2020 17:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [temp].[ABTClientes_NormData_PY]
@periodoevaluar int,
@periodoanterior int

AS

/***** filtros de datos ******/
/***** filtros de datos ******/

SELECT TOP 1010000 -- Memory error
	a.[id_cli_persona]
    ,a.[fec_datos]
    ,CASE WHEN a.[desc_segmento] = 'PREVISIONAL' THEN 1 ELSE 0 END AS desc_segmento_PREVISIONAL
    ,a.[per_flg_activo_de_4m]
    ,a.[txe_cant]
    ,a.[ctc_cant]
    ,a.[prods_cant]
    ,a.[hb_flag]
    ,a.[ope_tipo_operacion_SUELDO]
    ,a.[pza_flag]
	,a.anses_no_previsional
    ,CAST(a.[ctas_saldo_ars] AS FLOAT) AS [ctas_saldo_ars] 
    ,CAST(a.[ctas_cred_total_ars] AS FLOAT) AS [ctas_cred_total_ars]
    ,CAST(a.[inv_capital_ars] AS FLOAT) AS [inv_capital_ars]
    ,CAST(a.[txe_monto_mov_ars] AS FLOAT) AS txe_monto_mov_ars
	,CAST(a.[ctc_importe_origen_ars] AS FLOAT) AS ctc_importe_origen_ars
    ,CAST(a.[prestamos_personales_capintc] AS FLOAT) AS [prestamos_personales_capintc]

  INTO #ABTClientesTemp

  FROM [Analytics].[temp].[ABT_Clientes] A

  JOIN [Analytics].[temp].[ABT_Clientes] B
  ON a.[id_cli_persona] = b.[id_cli_persona]

  WHERE  a.fec_datos = @periodoevaluar AND b.fec_datos = @periodoanterior

  AND a.anses_no_previsional != 1
  AND a.per_flg_activo_de_4m = 1
;

EXECUTE sp_execute_external_script 
	  @language = N'Python'
    , @script = N'

import pandas as pd
import numpy as np

df = my_input_data

def df_cluster_simple(df):

    df["ope_tipo_operacion_SUELDO"] = np.where(df["ope_tipo_operacion_SUELDO"] >= 1,1,0)
    df["pza_flag"] = np.where(df["pza_flag"] >= 1,1,0)
    df["txe_ctc_monto_ars"] = df["txe_monto_mov_ars"] + df["ctc_importe_origen_ars"]

    df["ctas_saldo_ars"].values[df["ctas_saldo_ars"] < 0] = 0

    return df

df = df_cluster_simple(df)

OutputDataSet = df

'
, @input_data_1 = N'SELECT * FROM #ABTClientesTemp'
, @input_data_1_name = N'my_input_data'

  with result sets ((
	[id_cli_persona] int null,
	[periodo] int null,
	[desc_segmento_PREVISIONAL] int null,
	[per_flg_activo_de_4m] int null,
	[txe_cant] int null,
	[ctc_cant] int null,
	[prods_cant] int null,
	[hb_flag] int null,
	[ope_tipo_operacion_SUELDO] int null,
	[pza_flag] int null,
	[anses_no_previsional] int null,
	[ctas_saldo_ars] float null,
	[ctas_cred_total_ars] float null,
	[inv_capital_ars] float null,
	[txe_monto_mov_ars] float null,
	[ctc_importe_origen_ars] float null,
	[prestamos_personales_capintc] float null,
	[txe_ctc_monto_ars] float null));
