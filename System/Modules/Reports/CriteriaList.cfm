
<cf_screentop height="100%" html="No">

<cfparam name="URL.ID2" default="">

<cfset cnt = 0>

<cfquery name="Criteria" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControlCriteria
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#' 
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ReportControlCriteriaList
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#'
	ORDER BY ListOrder
</cfquery>

<cf_divscroll>

<cfform action="CriteriaListSubmit.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#" method="POST" name="fund">

	<table width="95%" align="left">
	    
	  <tr>
	    <td width="100%" class="regular">
	    <table width="100%" class="formpadding">
			
	    <TR class="labelmedium2 line fixrow">
		   <td width="28%">Value</td>
		   <td width="58%">Description</td>
		   <td>Sort</td>
		   <td width="10%" align="center">Enable</td>
		   <td style="width:20px"></td>
		   <td style="width:20px"></td>
	    </TR>	
		
		<cfoutput>
		<cfloop query="Detail">
		
		<cfset nm = ListValue>
		<cfset de = ListDisplay>
		<cfset od = ListOrder>
		<cfset op = Operational>
												
		<cfif URL.ID2 eq nm>
		
		    <input type="hidden" name="ListValue" id="ListValue" value="<cfoutput>#nm#</cfoutput>">
												
			<TR class="line labelmedium2">
			   <td>&nbsp;#nm#</td>
			   <td>
			   	   <cfinput type="Text" value="#de#" name="ListDisplay" message="You must enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
	           </td>
			    <td>
			   	   <cfinput type="Text"
			       name="ListOrder"
			       value="#od#"
			       message="You must enter a valid order"
			       validate="integer"			      	     
			       size="2"
			       maxlength="2"
			       class="regularxl">
	           </td>
			   <td class="regular" align="center">
			      <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif "1" eq Operational>checked</cfif>>
				</td>
			   <td colspan="2" style="padding-right:3px" align="right"><input style="width:80px" type="submit" value="Update" class="button10g"></td>
		    </TR>	
					
		<cfelse>
		
			<TR  class="line labelmedium2">
			   <td>#nm#</td>
			   <td>#de#</td>
			   <td>#od#</td>
			   <td align="center"><cfif op eq "0"><b>No</b><cfelse>Yes</cfif></td>
			   <td style="padding-left:5px">
			     <cfif URL.Status eq "0" or SESSION.isAdministrator eq "Yes">				  
			     <A href="CriteriaList.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#">
				 <img src="#SESSION.root#/Images/edit.gif" alt=""  border="0">
				 </a>
				 </cfif>
			   </td>
			   <td style="padding-left:5px">
			    <cfif URL.Status eq "0" or SESSION.isAdministrator eq "Yes">
			    <A href="CriteriaListPurge.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#nm#">
				<img src="#SESSION.root#/Images/delete5.gif" alt="" border="0">
				<a>
				</cfif>
			  </td>
			   
		    </TR>	
		
		</cfif>
						
		</cfloop>
		</cfoutput>
						
		<cfif URL.ID2 eq "" and (URL.Status eq "0" or SESSION.isAdministrator eq "Yes")>
					
			<TR  class="line labelmedium">
			<td>
			   <cfinput type="Text" name="ListValue" message="You must enter a value" required="Yes" size="20" maxlength="20" class="regularxl">			
			</td>
			
			<td>
			   <cfinput type="Text" name="ListDisplay" message="You must enter a description" required="Yes" size="30" maxlength="30" class="regularxl">
			</td>
			
			<td>
			  <cfinput type="Text"
			       name="ListOrder"
			       value="#detail.recordcount+1#"
			       message="You must enter a valid order"
			       validate="integer"			      	     
				   style="text-align:center"
			       size="1"
			       maxlength="2"
			       class="regularxl">
			</td>
			
			<td align="center">
				<input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
			</td>
								   
			<td colspan="2" align="right" style="padding-right:4px"><input  style="width:80px" type="submit" value=" Add " class="button10g"></td>
			    
			</TR>	
			
			<cfset cnt = cnt + 20>
								
		</cfif>	
		
		</table>
		
		</td>
		</tr>
					
	</table>			

	<cfoutput>
	<script language="JavaScript">
	
	{
	
	frm  = parent.document.getElementById("ilist");
	he = 28+#cnt#+#detail.recordcount*22#;
	frm.height = he
	}
	
	</script>
	</cfoutput>

</cfform>

</cf_divscroll>
