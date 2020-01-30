<cfparam name="url.reference"  default="">
<cfparam name="url.customerid" default="">
<cfparam name="url.mission"    default="">

<cfif len(url.reference) gt 0>

	<cfquery name="Validate" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			 SELECT * 
			 FROM   Customer
			 WHERE  Reference   = '#URL.Reference#'
			 AND    CustomerId != '#URL.CustomerId#'
			 AND    Reference  != ( SELECT CustomerDefaultReference FROM Ref_ParameterMission WHERE Mission = '#url.mission#' )
	
	</cfquery>
	
	<cfif Validate.recordcount gt 0>
		<font color="red">
			<cf_tl id="Reference alreay exists">.
		</font>
		<input type="hidden" value="0" name="validateReference" id="validateReference">
	<cfelse>
		<font color="#0080C0">
			<cf_tl id="Reference is valid">.
		</font>
		<input type="hidden" value="1" name="validateReference" id="validateReference">
	</cfif>

<cfelse>
		<input type="hidden" value="0" name="validateReference" id="validateReference">
</cfif>