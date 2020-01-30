
<HTML><HEAD>
<TITLE><cfoutput>#Header#</cfoutput></TITLE>
</HEAD>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">

<cf_wait>

<!--- <cf_wait Text="Retrieving information">  --->

<cfparam name="page" default="1">

<cfoutput>

<table width="100%" border="1" 
           bordercolor="silver" 
		   cellspacing="0" 
		   cellpadding="0" 
		   rules="rows" >

<tr>
	<td height="20" valign="middle" class="bannerN2">
		<cf_menuTopSelectedItem>
	</td>
	
	<td align="right" class="bannerN2"><font face="Verdana">
	&nbsp;<button onClick="javascript:recordadd()" class="buttonFlat" >Add #Header#</button>
	
	<cfif #page# eq "1">
	    &nbsp;
	    <cfinclude template="../../Tools/PageCount.cfm">
	    <select name="page" size="1" style="background: f4f4f4;" onChange="javascript:reloadForm(this.value)">
	       <cfloop index="Item" from="1" to="#pages#" step="1">
		        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
	       </cfloop>	 
	    </SELECT>  
	</cfif> 	
	
   </td>
</tr> 


<tr>
	<td colspan="2" bgcolor="ffffff">
		<cfinclude template="TopMenu.cfm">
	</td>
</tr>

</cfoutput>  	

<!--- continue with the table in the maintenance here --->

<cf_waitEnd>


