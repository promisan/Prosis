
<!--- ----------------------------------------- --->    
<!--- define field names----------------------- --->
<!--- ----------------------------------------- --->
 
 <cfquery name="Key" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 	
	SELECT * 
	FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#Broadcast.systemfunctionid#'		
	AND    FunctionSerialNo = '#Broadcast.functionserialNo#'	
 </cfquery>		

 <cfquery name="Mail" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 	
	SELECT * 
	FROM   Ref_ModuleControlDetailField
	WHERE  SystemFunctionId = '#Broadcast.systemfunctionid#'		
	AND    FunctionSerialNo = '#Broadcast.functionserialNo#'
	AND    FieldOutputFormat = 'eMail'
 </cfquery>	
 
 <cfquery name="Name" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 	
	SELECT * 
	FROM   Ref_ModuleControlDetailField
	WHERE  SystemFunctionId = '#Broadcast.systemfunctionid#'		
	AND    FunctionSerialNo = '#Broadcast.functionserialNo#'
	AND    FieldHeaderLabel = 'Name'
</cfquery>		
 
<!--- -------------------------------------------------------- --->    
<!--- generate the listing content and publish it as a view -- --->
<!--- -------------------------------------------------------- --->

<cfset url.systemFunctionId = BroadCast.systemFunctionId>
<cfset url.FunctionSerialNo = BroadCast.FunctionSerialNo>
<cfset url.showlist = "No">

<cf_inquiryContent>
				
<cfquery name="Listing" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 	
	SELECT * 
	FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#Broadcast.systemfunctionid#'		
	AND    FunctionSerialNo = '#Broadcast.functionserialNo#'			
</cfquery>		

<cfquery name="Drop"
	datasource="#Listing.QueryDataSource#">
     if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwListing#SESSION.acc#]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwListing#SESSION.acc#]
</cfquery>
 
<cftry>  
<cfquery name="View" 
    datasource="#Listing.QueryDataSource#">
	CREATE VIEW dbo.vwListing#SESSION.acc# AS
	#preservesinglequotes(session.listingquery)#    	
</cfquery> 	
<cfcatch></cfcatch>
</cftry>

<!--- define the fields in the table that can be used --->

<cfquery name="Fields" 
	datasource="#Listing.QueryDataSource#">
	SELECT   C.name, C.userType 
    FROM     SysObjects S, SysColumns C 
	WHERE    S.id = C.id
	AND      S.name = 'vwListing#SESSION.acc#'		
	ORDER BY C.ColId
</cfquery>		