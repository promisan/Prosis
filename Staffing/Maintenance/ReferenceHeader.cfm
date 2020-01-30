
<body leftmargin="5" topmargin="5" rightmargin="5" bottommargin="5">
<cfparam name="page" default="1">

<cfoutput>
 <tr class="noprint">
    <td height="23" class="top4n">
	<font face="Verdana"><b>&nbsp;#Header#</b></font>
	</td>
	
	<td align="right" class="top4n">
	&nbsp;<button onClick="javascript:recordadd()" class="buttonFlat" >Add #Header#</button>&nbsp;
	<cfif #page# eq "1">
	    <cfinclude template="../../Tools/PageCount.cfm">
	    <select name="page" size="1" style="background: e4e4e4;" onChange="javascript:reloadForm(this.value)">
	       <cfloop index="Item" from="1" to="#pages#" step="1">
		        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
	       </cfloop>	 
	    </SELECT>  
	</cfif> 	
	
	</td>
  </tr> 
</cfoutput>  	