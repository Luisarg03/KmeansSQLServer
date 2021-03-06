USE [DB]
GO
/****** Object:  Schema [dwm]    Script Date: 27/8/2020 17:37:47 ******/
CREATE SCHEMA [dwm]
GO
/****** Object:  Schema [temp]    Script Date: 27/8/2020 17:37:47 ******/
CREATE SCHEMA [temp]
GO
/****** Object:  Table [temp].[ABT_Clientes]    Script Date: 27/8/2020 17:37:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[ABT_Clientes](
	[id_cli_persona] [int] NULL,
	[fec_datos] [int] NULL,
	[desc_segmento] [varchar](80) NULL,
	[per_flg_activo_de_4m] [int] NULL,
	[txe_cant] [int] NULL,
	[ctc_cant] [int] NULL,
	[prods_cant] [int] NULL,
	[hb_flag] [int] NULL,
	[ope_tipo_operacion_SUELDO] [int] NULL,
	[pza_flag] [int] NULL,
	[ctas_saldo_ars] [numeric](38, 10) NULL,
	[ctas_cred_total_ars] [numeric](38, 10) NULL,
	[inv_capital_ars] [numeric](38, 10) NULL,
	[txe_monto_mov_ars] [numeric](38, 8) NULL,
	[ctc_importe_origen_ars] [numeric](38, 9) NULL,
	[prestamos_personales_capintc] [numeric](38, 2) NULL,
	[anses_no_previsional] [int] NULL,
	[inv_cant] [int] NULL,
	[pza_cant_INMUEBLE] [int] NULL,
	[pza_cant_ROBO] [int] NULL,
	[pza_cant_RIESSVARIOS] [int] NULL,
	[prestamos_personales_q] [int] NULL,
	[per_edad] [smallint] NULL,
	[per_antiguedad] [smallint] NULL,
	[per_sexo] [varchar](1) NULL,
	[pza_cant] [int] NULL,
	[ctc_usd_importe_origen] [numeric](38, 9) NULL,
	[tcc_producto_escala] [int] NULL,
	[com_importe_saldo] [numeric](38, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [temp].[ABTClientesClusters]    Script Date: 27/8/2020 17:37:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[ABTClientesClusters](
	[id_cli_persona] [int] NOT NULL,
	[periodo] [int] NOT NULL,
	[cluster] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [temp].[ABTClientesKmeansTrained]    Script Date: 27/8/2020 17:37:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[ABTClientesKmeansTrained](
	[model_name] [varchar](30) NOT NULL,
	[model] [varbinary](max) NOT NULL,
	[version] [varchar](20) NOT NULL,
	[examples] [int] NOT NULL,
	[CreateAt] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[model_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [temp].[ABTClientesNorm]    Script Date: 27/8/2020 17:37:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[ABTClientesNorm](
	[id_cli_persona] [int] NULL,
	[periodo] [int] NULL,
	[desc_segmento_PREVISIONAL] [int] NULL,
	[per_flg_activo_de_4m] [int] NULL,
	[txe_cant] [int] NULL,
	[ctc_cant] [int] NULL,
	[prods_cant] [int] NULL,
	[hb_flag] [int] NULL,
	[ope_tipo_operacion_SUELDO] [int] NULL,
	[pza_flag] [int] NULL,
	[anses_no_previsional] [int] NULL,
	[ctas_saldo_ars] [float] NULL,
	[ctas_cred_total_ars] [float] NULL,
	[inv_capital_ars] [float] NULL,
	[txe_monto_mov_ars] [float] NULL,
	[ctc_importe_origen_ars] [float] NULL,
	[prestamos_personales_capintc] [float] NULL,
	[txe_ctc_monto_ars] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [temp].[ABTClientesKmeansTrained] ADD  DEFAULT ('default model') FOR [model_name]
GO
ALTER TABLE [temp].[ABTClientesKmeansTrained] ADD  DEFAULT (getdate()) FOR [CreateAt]
GO
