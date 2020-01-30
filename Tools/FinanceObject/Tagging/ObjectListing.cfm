
<!--- Parameter : calling form --->

<cfparam name="URL.ent"  default=""> 
<cfparam name="URL.key" default="">
<cfparam name="URL.ref"  default=""> 
<cfparam name="URL.mis"  default=""> 
<cfparam name="URL.amt"  default="0"> 
<cfparam name="URL.cur"  default=""> 
<cfparam name="URL.lbl"  default="yes"> 
<cfparam name="URL.obj"  default=""> 
<cfparam name="URL.mde"  default="Single"> 
<cfparam name="URL.siz"  default="100%"> 

<cfif not find("%",url.siz)>
  <cfset url.siz = "#url.siz#%">   
</cfif>

<cfparam name="Attributes.Label"            default="#URL.lbl#">
<cfparam name="Attributes.TableWidth"       default="#url.siz#">
<cfparam name="Attributes.EntityCode"       default="#url.ent#">
<cfparam name="Attributes.ObjectKey"        default="#URL.key#">
<cfparam name="Attributes.Entry"            default="#url.mde#">
<cfparam name="Attributes.Object"           default="#URL.obj#">
<cfparam name="Attributes.ObjectReference"  default="#URL.ref#">
<cfparam name="Attributes.Mission"          default="#url.mis#">
<cfparam name="Attributes.Amount"           default="#url.amt#">
<cfparam name="Attributes.Currency"         default="#url.cur#">

<cfif not IsNumeric(URL.amt)>
  <table><tr><td class="labelmedium" align="center"><font color="FF0000">Incorrect amount entered : <cfoutput>#URL.amt#</cfoutput>. Please enter a valid numeric number.</b></font></td></tr></table>
  <cfabort>
</cfif>

<!---
<cfparam name="Attributes.ObjectURL"        default="">
--->
<cfparam name="Attributes.Create"           default="Yes">
<cfparam name="Attributes.Show"             default="Yes">
<cfparam name="Attributes.Toolbar"          default="Yes">
<cfparam name="Attributes.FrameColor"       default="f4f4f4">

<cf_verifyOperational module="Accounting" Warning="No">
 
<cfif operational eq "1">
	
	<!--- put the pk of the entity in a variable --->
	<cfset condition = " AND O.EntityCode = '#Attributes.EntityCode#'">
	
	<cfquery name="Ent" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Entity
		WHERE    EntityCode = '#Attributes.EntityCode#'
	</cfquery>
	
	<cfif Ent.EntityKeyField1 neq "">
	  <cfset f = "1">
	  <cfset key = "#Ent.EntityKeyField1#">
	<cfelse>
	  <cfset f = "4">
	  <cfset key = "#Ent.EntityKeyField4#">
	</cfif>
	
	<cfset val = evaluate("Attributes.ObjectKey")>
	<cfset condition = condition&" AND O.ObjectKeyValue#f# = '#val#'">	
	
	<cfinclude template="ObjectCreate.cfm">
		
	<cfquery name="Check" 
	 datasource="AppsLedger"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   FinancialObject O, Ref_Entity R
		 WHERE  O.EntityCode   = '#Attributes.EntityCode#' 
		 AND    R.EntityCode = O.EntityCode
		 AND    Operational = 1
		 #preserveSingleQuotes(condition)#
	</cfquery>
	
	<cfif Check.recordcount eq "0">
		<cfexit method="EXITTEMPLATE">
	</cfif>	
	
	<cfset ObjectId = "#Check.ObjectId#">
	
	<cfif Attributes.Show eq "Yes"> 
	
		<cfinclude template="ObjectListingView.cfm"> 
		
	</cfif>

</cfif>

