
<cfif url.mode eq "Formula">
	
	<cfquery name="Update" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    GroupFormula = '#URL.action#'
	 WHERE  UserAccount  = '#SESSION.acc#'
	 AND    OutputId     = '#URL.ID#'
	 AND    OutputClass  = 'Detail'
	 AND    FieldName    = '#URL.Name#' 
	</cfquery>
	
	<cfoutput>

		<cfif url.action eq "None">
		   <a href="javascript:update('formula','#url.name#','SUM','#url.id#','#url.box#')">Yes</a>&nbsp;|&nbsp;<font color="0080FF">No</font></b>
		<cfelseif url.action eq "SUM">
		   <font color="800000">Yes&nbsp;</font>|&nbsp;<a href="javascript:update('formula','#url.name#','None','#url.id#','#url.box#')">No</a>
		</cfif>
	
	</cfoutput>

<cfelseif url.mode eq "Sorting">

	<cfquery name="Update" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    OutputSorting = '#URL.action#'
	 WHERE  UserAccount = '#SESSION.acc#'
	 AND    OutputId = '#URL.ID#'
	 AND    OutputClass = 'Detail'
	 AND    FieldName = '#URL.Name#' 
	</cfquery>
	
	<cfoutput>
	
	<cfif url.action eq "">
		   <a href="javascript:update('sorting','#url.name#','ASC','#url.id#','#url.box#')">ASC</a>&nbsp;|
		   <a href="javascript:update('sorting','#url.name#','DESC','#url.id#','#url.box#')">DESC</a>&nbsp;|
		   <font color="800000">NONE</font>
	<cfelseif url.action eq "ASC">
		   <font color="800000">ASC</font>&nbsp;|			   
		   <a href="javascript:update('sorting','#url.name#','DESC','#url.id#','#url.box#')">DESC</a>&nbsp;|
		   <a href="javascript:update('sorting','#url.name#','','#url.id#','#url.box#')">NONE</a>			  
	<cfelse>
		   <a href="javascript:update('sorting','#url.name#','ASC','#url.id#','#url.box#')">ASC</a>&nbsp;|
		   <font color="800000">DESC</font>&nbsp;|			   
		   <a href="javascript:update('sorting','#url.name#','','#url.id#','#url.box#')">NONE</a>	  
	</cfif>

	</cfoutput>
	
<cfelseif url.mode eq "Label">	

	<cfquery name="Update" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    OutputHeader = '#URL.action#'
	 WHERE  UserAccount = '#SESSION.acc#'
	 AND    OutputId = '#URL.ID#'
	 AND    OutputClass = 'Detail'
	 AND    FieldName = '#URL.Name#' 
	</cfquery>
	
<cfelseif url.mode eq "up">

	<cfquery name="Current" 
	 datasource="appsSystem">
	 SELECT FieldNameOrder
	 FROM   UserReportOutput 	 
	 WHERE  UserAccount = '#SESSION.acc#'
	 AND    OutputId    = '#URL.ID#'
	 AND    OutputClass = 'Detail'
	 AND    FieldName   = '#URL.Name#' 
	</cfquery>
	
	<cfquery name="Above" 
	 datasource="appsSystem">
	 SELECT TOP 1 FieldName
	 FROM   UserReportOutput 	 
	 WHERE  UserAccount  = '#SESSION.acc#'
	 AND    OutputId     = '#URL.ID#'
	 AND    OutputClass  = 'Detail'
	 AND    FieldNameOrder < '#Current.FieldNameOrder#' 
	 ORDER BY FieldNameOrder DESC
	</cfquery>
	
	<cfquery name="MoveDownAbove" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    FieldNameOrder = '#Current.FieldNameOrder#'
	 WHERE  UserAccount    = '#SESSION.acc#'
	 AND    OutputId       = '#URL.ID#'
	 AND    OutputClass    = 'Detail'
	 AND    FieldName      = '#Above.FieldName#' 
	</cfquery>

	<cfquery name="MoveUp" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    FieldNameOrder = FieldNameOrder-1
	 WHERE  UserAccount    = '#SESSION.acc#'
	 AND    OutputId       = '#URL.ID#'
	 AND    OutputClass    = 'Detail'
	 AND    FieldName      = '#URL.Name#' 
	</cfquery>
	
	<cfinclude template="FormatExcelDetailSelected.cfm">	
	
<cfelseif url.mode eq "down">

	<cfquery name="Current" 
	 datasource="appsSystem">
	 SELECT FieldNameOrder
	 FROM   UserReportOutput 	 
	 WHERE  UserAccount = '#SESSION.acc#'
	 AND    OutputId = '#URL.ID#'
	 AND    OutputClass = 'Detail'
	 AND    FieldName = '#URL.Name#' 
	</cfquery>
	
	<cfquery name="Below" 
	 datasource="appsSystem">
	 SELECT TOP 1 FieldName
	 FROM   UserReportOutput 	 
	 WHERE  UserAccount = '#SESSION.acc#'
	 AND    OutputId = '#URL.ID#'
	 AND    OutputClass = 'Detail'
	 AND    FieldNameOrder > '#Current.FieldNameOrder#' 
	 ORDER BY FieldNameOrder ASC
	</cfquery>
	
	<cfquery name="MoveUpBelow" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    FieldNameOrder = '#Current.FieldNameOrder#'
	 WHERE  UserAccount    = '#SESSION.acc#'
	 AND    OutputId       = '#URL.ID#'
	 AND    OutputClass    = 'Detail'
	 AND    FieldName      = '#Below.FieldName#' 
	</cfquery>
	
	<cfquery name="MoveDown" 
	 datasource="appsSystem">
	 UPDATE UserReportOutput 
	 SET    FieldNameOrder = FieldNameOrder+1
	 WHERE  UserAccount    = '#SESSION.acc#'
	 AND    OutputId       = '#URL.ID#'
	 AND    OutputClass    = 'Detail'
	 AND    FieldName      = '#URL.Name#' 
	</cfquery>
	
	<cfinclude template="FormatExcelDetailSelected.cfm">
		

</cfif>


