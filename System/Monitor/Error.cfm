<cfquery name="Drop"
	datasource="AppsQuery">
      if exists (select * from dbo.sysobjects 
	             where id = object_id(N'[dbo].[vwUserError]') 
            	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwUserError]
	</cfquery>
 
<cfquery name="Dataset" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	CREATE VIEW dbo.vwUserError
	AS
	SELECT  E.Account AS Account_dim, 
	        N.FirstName + ' ' + N.LastName AS Account_nme, 
			E.HostServer AS Host_dim, 
			YEAR(E.ErrorTimestamp) AS Year_dim, 
            MONTH(E.ErrorTimestamp) AS Month_dim, 
			E.TemplateGroup as Module_dim,
			E.FileName AS FileName_dim, 
			E.ErrorTimestamp, 
			E.ErrorReferer, 
			E.ErrorTemplate, 
			E.ErrorString, 
            E.ErrorDiagnostics,
			E.ErrorId as FactTableId	
	FROM    System.dbo.UserError AS E INNER JOIN
            System.dbo.UserNames AS N ON E.Account = N.Account
</cfquery>	