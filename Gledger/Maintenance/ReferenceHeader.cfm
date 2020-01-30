
<cfparam name="page" default="1">

<cfparam name="addButton" default="1">

<cfoutput>
 <tr class="noprint">
    <td height="30" class="top4n">
	<font face="Verdana"><b>&nbsp;#Header#</b></font>
	</td>
	<td align="right" class="top4n">
	<cfif #addButton# eq "1">
	&nbsp;<button onClick="javascript:recordadd()" class="buttonFlat" >Add #Header#</button>&nbsp;
	</cfif>
	<cfif page eq "1">
	    <cfinclude template="../../Tools/PageCount.cfm">
	    <select name="page" size="1" style="background: C9D3DE;" onChange="javascript:reloadForm(this.value)">
	       <cfloop index="Item" from="1" to="#pages#" step="1">
		        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
	       </cfloop>	 
	    </SELECT>  
	</cfif> 	
	</td>
  </tr> 
</cfoutput>  	