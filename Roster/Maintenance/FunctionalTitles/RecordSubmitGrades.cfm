<cfquery name="Update" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE FunctionTitleGrade
SET    Operational = 0
WHERE  FunctionNo  = '#Form.FunctionNoOld#' 
</cfquery>

<cfif isDefined("form.selected")>

<cfloop index="Item" list="#Form.Selected#" delimiters=",">
	 
	<cfquery name="Check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   FunctionTitleGrade
		WHERE  FunctionNo  = '#Form.FunctionNoOld#'
		AND    GradeDeployment = '#Item#'  
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="InsertGrade" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO FunctionTitleGrade
		         (FunctionNo,
				 GradeDeployment,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.FunctionNoOld#',
		          '#Item#', 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
	
	<cfelse>
	
		<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE FunctionTitleGrade
			SET    Operational = 1
			WHERE FunctionNo  = '#Form.FunctionNoOld#'
			AND   GradeDeployment = '#Item#'
		</cfquery>
	
	</cfif>
	
	</cfloop>

</cfif>

<cfquery name="checkJP" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	FunctionTitleGrade
		WHERE  	FunctionNo  = '#Form.FunctionNoOld#' 
		AND     Operational = 1
</cfquery>

<table>
	
	<cfif checkJP.recordCount gt 0>
	<tr><td height="5"></td></tr>
	<TR>
	    <td height="30" align="center" valign="middle" class="labelmedium">
		  	<cfoutput>
		   	<img src="#SESSION.root#/images/finger.gif"><a href="javascript:maintain('#Form.FunctionNoOld#')"><b><u><font color="0080FF">Maintain Job Profiles</b></a>
			</cfoutput>
		</td>
	</TR>
	</cfif>
</table>

