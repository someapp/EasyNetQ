/****** Object:  StoredProcedure [dbo].[uspWorkItemsSelfPurge]    Script Date: 11/25/2011 15:05:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[uspWorkItemsSelfPurge] @rows TinyINT = 5, @purgeDate DateTime = NULL 

AS
/******************************************************************************
**		File: uspWorkItemsSelfPurge.sql
**		Name: uspWorkItemsSelfPurge 
**		Desc: Example table purging technique to run as a regular scheduled task
**
**		Auth: Steve Smith
**		Date: 20111115
**
**      Uses: @rows = number of rows to delete at a time
**				@purgeDate = date to delete, defaults to now
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------	--------			-------------------------------------------
**		20111125	Steve Smith			Original creation for demonstration
*******************************************************************************/

IF @purgeDate is NULL SET @purgeDate=getdate()

-- Only execute if there is work to do and continue 
-- until all records with a PurgeDate <= now are deleted
WHILE EXISTS(SELECT * FROM WorkItemStatus WHERE PurgeDate <= @purgeDate) 
BEGIN
	-- NB:  the FK in WorkStatus has ON DELETE CASCADE,
	-- so it will delete corresponding rows automatically
	DELETE TOP (@rows) 
	FROM WorkItemStatus
	WHERE PurgeDate <= @purgeDate
END -- WHILE EXISTS(
