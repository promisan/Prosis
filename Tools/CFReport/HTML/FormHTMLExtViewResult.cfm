
<cfparam name="url.mult" default="1">

<cfquery name="PK" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM  Ref_ReportControlCriteria
	  WHERE ControlId = '#URL.ControlId#'
	  AND   CriteriaName = '#URL.CriteriaName#'
	  AND Operational = 1
 </cfquery>
 
 <cfset Crit = replaceNoCase(PK.CriteriaValues, "@userid", SESSION.acc , "ALL")>
 <cfset Crit = replaceNoCase(Crit,"@manager", SESSION.isAdministrator,"ALL")>
 <cfset Crit = replaceNoCase(Crit, "WHERE", "" , "ALL")>			
 
 <cfquery name="Fields" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     Ref_ReportControlCriteriaField 
  WHERE    ControlId = '#URL.ControlId#'
  AND      CriteriaName = '#URL.CriteriaName#'
  ORDER BY FieldOrder
 </cfquery>
      
 <cfset Criteria = "">
  
 <cfloop query="Fields">
 
    <cfparam name="fldname#currentrow#" default="#FieldName#">
	<cfparam name="flddisp#currentrow#" default="#FieldDisplay#">
 
    <cfparam name="FORM.#Fields.FieldName#" default="all">
	
    <cfset val   = Evaluate("FORM." & #Fields.FieldName#)>
	<cfset val   = Replace(val, "'", "", "ALL")>
	
	<cfif Find("All", #val#) and #len(val)# lte 5>
	
	    <cfset fil = "">
	
	<cfelse> 

        <cfset val   = Replace(val, "All", "", "ALL")> 
		<cfset fil = "">
		<cfloop index="itm" list="#val#" delimiters=",">
	       	 <cfif fil eq "">
		    	<cfset fil = "'#itm#'">
			 <cfelse>
			    <cfset fil = "#fil#,'#itm#'">
			 </cfif>
		</cfloop>
		
    </cfif>
	
    <cfif fil neq "" and fil neq "'all'">
    
	     <CFSET Criteria = Criteria&" AND S.#Fields.FieldName# IN (#fil#)">
		 
	<cfelseif fil eq "" and LookupUnitTree neq "None">
	
		<cfif LookupUnitTree neq "NONE">
	 
	 		<cfquery name="Mandate" 
			 datasource="AppsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   SELECT Mission,MandateNo
			   FROM Ref_Mandate
			   WHERE Mission = '#LookupUnitTree#'
			   ORDER BY MandateDefault DESC
			</cfquery>	   
	 
	    </cfif>			
		 
		<cfquery name="Init" 
		   datasource="AppsSystem">
		   SELECT     * 
		   FROM       Parameter
		</cfquery>	
	
		<cfsavecontent variable="criteria">
	     
		 	<cfoutput>
		    #Criteria# AND S.#Fields.FieldName# IN (
	  
			  		   SELECT DISTINCT Org.OrgUnitCode
					   FROM [#Init.DatabaseServer#].Organization.dbo.OrganizationAuthorization A,
					        [#Init.DatabaseServer#].Organization.dbo.Organization Org
					   WHERE A.OrgUnit   = Org.OrgUnit	
					   AND   Org.Mission   = '#Mandate.Mission#'
					   AND   Org.MandateNo = '#Mandate.MandateNo#'	   			  
					   AND   HierarchyCode is not NULL
					   <cfif SESSION.isAdministrator eq "No">
					   AND   A.UserAccount = '#SESSION.acc#'
					   AND   A.Role IN (SELECT Role 
					                    FROM System.dbo.Ref_ReportControlRole 
									    WHERE ControlId = '#ControlId#')
					   </cfif>					 
					   UNION
					   SELECT DISTINCT Org.OrgUnitCode
					   FROM [#Init.DatabaseServer#].Organization.dbo.OrganizationAuthorization A,
					        [#Init.DatabaseServer#].Organization.dbo.Organization Org
					   WHERE A.Mission = Org.Mission	
					   AND   Org.Mission   = '#Mandate.Mission#'
					   AND   Org.MandateNo = '#Mandate.MandateNo#'
					   AND   (A.OrgUnit is NULL or A.OrgUnit = '')
					   AND   HierarchyCode is not NULL
					   AND   A.UserAccount = '#SESSION.acc#'
					   AND   A.Role IN (SELECT Role 
					                    FROM System.dbo.Ref_ReportControlRole 
									    WHERE ControlId = '#ControlId#') 
					  				   
					   )
				</cfoutput>		   
		  </cfsavecontent>		
		     
	  					 
	</cfif> 
		
  </cfloop>
	
  
  <cfquery name="Check" 
  datasource="#PK.LookupDataSource#" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT count(*) as Total
  FROM  #PK.LookupTable# S 
  WHERE #PK.LookupFieldValue# NOT IN (SELECT PK 
                                      FROM userQuery.dbo.#SESSION.acc#_crit_#URL.CriteriaName#)
   #preserveSingleQuotes(Criteria)#   
   <cfif Crit neq "">
	  AND #preserveSingleQuotes(Crit)# 
   </cfif> 
  </cfquery>
    
  <cfif Check.total gt "1000">
  
	   <cf_waitEnd Frm="result"> 
	  <cf_message Message="Your search will exceed the maximum number of 1000 combinations. <br><b>Please specify your criteria again."
	  return="no">
	  <cfabort>
  
  </cfif>
  
  <cfquery name="Values" 
  datasource="#PK.LookupDataSource#" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT <cfif Left("#PK.CriteriaValues#","8") neq "ORDER BY"> DISTINCT</cfif> 
	  <cfoutput query="Fields">
	  <cfif fieldDisplay neq "">#fieldDisplay#<cfelse>#FieldName#</cfif>,
	  </cfoutput>
	  <cfif PK.LookupFieldDisplay neq "">
		    #PK.LookupFieldDisplay# as Display, 
		   <cfelse>
		    #PK.LookupFieldValue# as Display,	
	  </cfif>	 
	 
	  #PK.LookupFieldValue# as PK
	  FROM  #PK.LookupTable# S 
	  WHERE #PK.LookupFieldValue# NOT IN (SELECT PK 
	                                      FROM userQuery.dbo.#SESSION.acc#_crit_#URL.CriteriaName#)
	   #preserveSingleQuotes(Criteria)#  
	   <cfif Crit neq "">
		  AND #preserveSingleQuotes(Crit)#
	   </cfif>
	  <cfif Left("#PK.CriteriaValues#","8") eq "ORDER BY"> 
		  #PK.CriteriaValues#
	  </cfif>
  </cfquery>
 
<cfform action="FormHTMLExtViewResultSubmit.cfm?mult=#URL.Mult#&row=#URL.row#&ControlID=#URL.ControlId#&ReportID=#URL.ReportId#&CriteriaName=#URL.CriteriaName#" method="post">
 
<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center"class="navigation_table">

	<cfoutput>
	<tr><td colspan="#Fields.recordcount+2#" class="line"></td></tr>
	</cfoutput>
	 
	<tr>
	    <td valign="top"></td> 	
		<cfoutput query="Fields">
		    <td class="labelit"><b><cfif FieldDescription neq "">#FieldDescription#<cfelse>[#fieldName#]</cfif></td>
		</cfoutput>
	    <td align="center" width="5%">
			<input type="checkbox" class="radiol" name="selectall" id="selectall" value="" checked onClick="javascript:selall(this,this.checked)">
		</td>
	</tr>
	

<cfoutput query="Values">
	
	<tr class="navigation_row linedotted">
	
	    <td class="labelmedium" style="height:20px;padding-left:3px">#currentrow#.</td> 	
		
		<cfloop index="No" from="1" to="#Fields.recordcount#">
		    <td class="labelmedium" style="height:20px;padding-left:3px">
			<cfif Evaluate(Evaluate("flddisp#No#")) eq "">
				<cfset val  = Evaluate(Evaluate("fldname#No#"))>#val#
			<cfelse>
				<cfset val  = Evaluate(Evaluate("flddisp#No#"))>#val#
			</cfif>	
				
			</td>
		</cfloop>
		
		<td class="labelmedium" align="center" style="height:20px">
			<input type="checkbox" name="select" id="select" value="'#PK#'" checked onClick="javascript:hl(this, this.checked)">
		</td>
	
	</tr>		

</cfoutput>

 <tr>
     <td style="padding-top:5px"
		 colspan="<cfoutput>#Fields.recordcount+3#</cfoutput>" 
	     align="center">
		   <input type= "submit" class="button10g" style="width:150px;height:23" name="search1" id="search1" value = "Done">
	 </td>
 </tr>

 
</table>

<cfset ajaxonload("doHighlight")>

</cfform>


