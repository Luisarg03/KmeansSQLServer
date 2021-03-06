USE [DB]
GO
/****** Object:  StoredProcedure [temp].[ABTClientes_FIT_MODEL_SAVE_SP]    Script Date: 27/8/2020 17:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [temp].[ABTClientes_FIT_MODEL_SAVE_SP] @name_model VARCHAR(50), @version VARCHAR(20) AS

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ABTClientesKmeansTrained'
		   AND TABLE_SCHEMA = 'temp')

CREATE TABLE [Analytics].[temp].[ABTClientesKmeansTrained] (
    model_name VARCHAR(30) NOT NULL DEFAULT('default model') PRIMARY KEY,
    model VARBINARY(MAX) NOT NULL,
	version VARCHAR(20) NOT NULL,
	examples INT NOT NULL,
	CreateAt DATE DEFAULT GETDATE())

DECLARE
@model VARBINARY(MAX),
@examples INT
EXECUTE [temp].[ABTClientes_FIT_MODEL_PY] @model OUTPUT, @examples OUTPUT;
INSERT INTO [Analytics].[temp].[ABTClientesKmeansTrained] (model_name, model, version, examples)
VALUES(@name_model, @model, @version, @examples);
