
<cfparam name="attributes.ShowPage"     default="1">
<cfparam name="attributes.ShowAdd"      default="1">
<cfparam name="attributes.ShowMenu"     default="1">
<cfparam name="attributes.AddHeader"    default="">
<cfparam name="attributes.Width"        default="100%">
<cfparam name="attributes.Border"       default="1">
<cfparam name="attributes.BorderColor"  default="silver">
<cfparam name="attributes.IDMenu"       default="">
<cfparam name="URL.IDRefer" default="">

<cfif Attributes.IDMenu neq "">

<cfoutput>

<table width="#Attributes.Width#"
       border="0"
	   height="28"
	   align="center"
       cellspacing="0"
       cellpadding="0">
	   
<tr><td height="20"></td></tr>	   
	    
<tr id="menu" class="regular">

	<td align="left" style="padding-left:50px" valign="bottom">
	
		<cfif attributes.showmenu eq "1">
		
		<!--- show menu --->
				
		<cfparam name="URL.IDRefer" default="">
		
		<cfloop index="menu" from="1" to="4">
			<cfparam name="attributes.Header#menu#" default="">
			<cfparam name="attributes.FunctionClass#menu#" default="">
			<cfparam name="attributes.MenuClass#menu#" default="">
		</cfloop>
		
		<cf_menuTopHeader
		  idrefer        = "#attributes.idRefer#"
		  idmenu         = "#attributes.idMenu#"
		  template       = "#attributes.template#"
		  systemModule   = "#attributes.systemModule#"
		  items          = "#attributes.items#"
		  Header1        = "#attributes.Header1#"
		  FunctionClass1 = "#attributes.FunctionClass1#"
		  MenuClass1     = "#attributes.MenuClass1#"
		  Header2        = "#attributes.Header2#"
		  FunctionClass2 = "#attributes.FunctionClass2#"
		  MenuClass2     = "#attributes.MenuClass2#"
		  Header3        = "#attributes.Header3#"
		  FunctionClass3 = "#attributes.FunctionClass3#"
		  MenuClass3     = "#attributes.MenuClass3#"
		  Header4        = "#attributes.Header4#"
		  FunctionClass4 = "#attributes.FunctionClass4#"
		  MenuClass4     = "#attributes.MenuClass4#">
			
		</cfif>	
										  
	</td>
	
	<td align="right" style="padding-top:5px">
		
		<cfquery name="Item" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_ModuleControl
			WHERE    SystemFunctionId = '#URL.IDMenu#'
		</cfquery>	
		
		<font face="Verdana" size="1">&nbsp;
		<cfif URL.IDrefer neq "undefined" and URL.IDRefer neq "">
		<a href="javascript:history.back()" title="Menu">
		<font color="0080C0">#URL.IDrefer#</font></a>->
		<cfelse>
		#Item.FunctionClass# -> 
		</cfif>
		<b><font color="gray">#Item.FunctionName#</font></b>
		&nbsp;	  
	</td>
	
 </tr> 
 
</table>

</cfoutput>  	

</cfif>



