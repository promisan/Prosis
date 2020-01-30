
<cfquery name="Asset" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   AssetItem A, Item I
	WHERE  AssetId = '#URL.Assetid#'	
	AND    A.ItemNo = I.ItemNo
</cfquery>

<!--- check access rights --->

<cfinvoke component = "Service.Access"  
   method           = "AssetHolder" 
   mission          = "#Asset.Mission#" 
   assetclass       = "#Asset.category#"
   returnvariable   = "access">	

<cfif access eq "ALL" or Access eq "EDIT">
 <cfset mode = "edit">
<cfelse>
 <cfset mode = "view">
</cfif>   

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td height="600" id="picturebox">

    <cf_PictureView documentpath="Asset"
        subdirectory="#url.assetid#"
		filter="Picture_" 							
		width="500" 
		height="500"
		mode="#mode#">		

</td></tr>

</table>