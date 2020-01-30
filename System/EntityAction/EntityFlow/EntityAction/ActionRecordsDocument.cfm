<!--- ----------------------------------------- --->
<!--- show fields to be associated to an action --->
<!--- ----------------------------------------- --->

<cfif url.entitycode eq "">
	<cfabort>
</cfif>

<cfset box = replace(url.actioncode,"-","","ALL")> 
		
<table cellspacing="0" width="98%"  align="right" border="0" cellpadding="0">

<cfset show = 0>

<cfloop index="itm" list="Report,Attach,Field,Question" delimiters=",">
	
	<cfquery name="GroupAll" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_EntityDocument R 
		WHERE   R.EntityCode = '#URL.EntityCode#'
		AND     R.DocumentType = '#itm#'
		<cfif itm eq "Attach">
		AND     R.DocumentMode = 'step'
		</cfif>
		AND     R.Operational = 1
		ORDER BY DocumentOrder 
	 </cfquery>		 

	 <cfif GroupAll.recordcount neq "0">
	 
	 <tr  class="labelmedium line">
		 <td colspan="4" style="font-size:15px;font-weight:200;height:29px"><cfoutput><cf_tl id="#itm#"></cfoutput>:</td>
	 </tr>
	 
	 <cfset show = 1>
	 	 	 
	 <cfset r = 0>
	 		 		 
	 <cfoutput query="GroupAll">
	 
	    <cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityActionDocument R 
			WHERE  R.ActionCode = '#URL.actioncode#'
			 AND   R.DocumentId = '#DocumentId#'				
		</cfquery>   
									
	    <cfif r eq "0"><TR style="height:15px"></cfif>
					
			<td width="33%">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfif check.recordcount eq "0">
					      <TR class="regular" style="height:16px">
				<cfelse>  <TR class="highlight2" style="height:16px">
				</cfif>
			   
				<TD style="padding-left:6px;width:30px">	
				<cfif Check.Recordcount eq "0">
					<input type="checkbox" name="Document" id="Document" value="#DocumentId#" onClick="hl(this,this.checked)"></TD>
				<cfelse>
					<input type="checkbox" name="Document" id="Document" value="#DocumentId#" checked onClick="hl(this,this.checked)"></td>
			    </cfif> 
				<TD class="labelit" style="padding-right:6px">#DocumentDescription#</TD>
				</table>
			</td>
			<cfif GroupAll.recordCount eq "1">
					<td width="33%"></td>
			</cfif>
	  			<cfif r neq 2>
				   <cfset r = r+1>
				<cfelse>
				   <cfset r = 0>
				</TR></cfif> 	
				
	    </CFOUTPUT>
	
	</cfif>
	

</cfloop>

<cfif show eq "1">
	
	<cfoutput>
	   <tr style="border-top:1px solid silver">
		 <td colspan="4" height="34" align="center">
		 
			 <input type="button" 
				 class="button10g" 
				 value="Close" 
				 style="width:100px"
				 onClick="object('#box#','#url.actioncode#')" 
				 name="Close" id="Close">
			 
			 <input type="button" 
				 style="width:100px" 
				 class="button10g" 
				 value="Save" 
				 onClick="objectsave('#box#','#url.actioncode#')" 
				 name="Save" id="Save">		 
				 
		 </td>
	   </tr>
	</cfoutput>	 
	
<cfelse>

	<tr><td colspan="4" align="center" class="labelmedium">No objects founds</td></tr>	

</cfif>
	
</table>
		
	

