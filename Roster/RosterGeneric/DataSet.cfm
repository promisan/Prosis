
<cfparam name="url.idmenu" default="">

<cfquery name="Function" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ModuleControl
	<cfif url.idmenu neq "">
	WHERE   SystemFunctionId = '#URL.idmenu#' 
	<cfelse>
	WHERE 1 = 0
	</cfif>
	</cfquery>
		
<cf_screentop height="100%" scroll="No" html="No" layout="innerbox" title="#Function.FunctionName#" blockevent="rightclick">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr><td>
					
			<iframe name="invokedetail"
			        id="invokedetail"
			        width="100%"
			        height="100%"
			        scrolling="no"
			        frameborder="0"></iframe>
								
			<cfquery name="System" 
			datasource="AppsSystem">
				SELECT * FROM Parameter
			</cfquery>	
												
												
			<cfinvoke component="Service.Analysis.CrossTab"  
			  method      = "ShowInquiry"	  
			  reportPath  = "Roster/RosterGeneric/"
			  SQLtemplate = "RosterStatus.cfm"
			  queryString = "owner=#url.owner#&header=0"
			  dataSource  = "appsQuery" 
			  module      = "Roster"
			  reportName  = "Facttable: Roster Status"
			  olap        = "1"			 
			  table1Name  = "Roster"
			  table1Class = "variable"		  	
			  table1drill = ""		  
			  invoke      = "Yes"
			  filter      = "0"> 	
			
	</td>
	</tr>

</table>	