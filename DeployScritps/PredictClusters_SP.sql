USE [DB]
GO
/****** Object:  StoredProcedure [temp].[ABTClientes_PredictClusters_SP]    Script Date: 27/8/2020 17:35:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [temp].[ABTClientes_PredictClusters_SP] @name_model_to_use varchar(40) AS

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ABTClientesClusters'
		   AND TABLE_SCHEMA = 'temp')
DROP TABLE [temp].[ABTClientesClusters];

CREATE TABLE [Analytics].[temp].[ABTClientesClusters] (
   [id_cli_persona] int not null,
	[periodo] int not null,
	[cluster] int not null
);

INSERT INTO [Analytics].[temp].[ABTClientesClusters]
EXECUTE [temp].[ABTClientes_PredictCusters_PY] @name_model_to_use;
