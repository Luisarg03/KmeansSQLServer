USE [DB]
GO
/****** Object:  StoredProcedure [temp].[ABTClientes_NormData_SP]    Script Date: 27/8/2020 17:35:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [temp].[ABTClientes_NormData_SP]
@periodoevaluar int,
@periodoanterior int

AS

/***** Limpieza de procesos anteriores ******/
/***** Limpieza de procesos anteriores ******/

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ABTClientesNorm'
			   AND TABLE_SCHEMA = 'temp')
	DROP TABLE [Analytics].[temp].[ABTClientesNorm];

/***** Creacion de tablas necesarias ******/
/***** Creacion de tablas necesarias ******/

CREATE TABLE [temp].[ABTClientesNorm](
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
	[txe_ctc_monto_ars] float null)

;

INSERT INTO [temp].[ABTClientesNorm]
EXECUTE [temp].[ABTClientes_NormData_PY] @periodoevaluar, @periodoanterior
