<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->


<!--- SAT, procurement contract follow-up template
There are three fields which are custom fields. 
Please embed these fields ala Insight into this template 
after carolina informs you about the field reference number 
they have in SAT
 ---->



<cfquery name="JobEvent" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM Job J,Ref_OrderClass R
	WHERE J.OrderClass = R.Code
	AND J.JobNo = '#URL.JobNo#'	
</cfquery>
<cfloop index="itm" list="001,ND014,FC014">	

	<cfquery name="qry_#itm#"
	   datasource="AppsOrganization"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
		  SELECT DocumentItemValue as value
		  FROM   OrganizationObjectInformation
		  WHERE  ObjectId in (SELECT ObjectId
						       FROM   OrganizationObject
						       WHERE  ObjectKeyValue1='#URL.JobNo#')							  
		  AND DocumentId IN
			     (SELECT   DocumentId
			      FROM  Ref_EntityDocument
			      WHERE EntityCode = 'ProcJob'
			      AND   DocumentCode = '#itm#')
				    
	  </cfquery>
			  
</cfloop>

<cfoutput>	

	<TR class="labelmedium">
	 <TD height="18"><cf_tl id="JobTrigger">:</TD>
	 <TD><font color="0080FF"><cfif qry_001.value eq "">--<cfelse>#qry_001.value#</cfif></TD>
	</TR>
	
	<TR class="labelmedium">
    <TD height="18"><cf_tl id="Event">:</TD>
    <TD class="labelit"><font color="0080FF">#JobEvent.Description#</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD height="18"><cf_tl id="Contract No">:</TD>	
	<TD><font color="0080FF"><cfif qry_ND014.value eq "">--<cfelse>#qry_ND014.value#</cfif></td>
	</TR>
	
	<TR class="labelmedium">
    <TD height="18"><cf_tl id="Subscription date">:</TD>	
	<TD><font color="0080FF"><cfif qry_FC014.value eq "">--<cfelse>#qry_FC014.value#</cfif></td>
	</TR>	
	
</cfoutput>		
