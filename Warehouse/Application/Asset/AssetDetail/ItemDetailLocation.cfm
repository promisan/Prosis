<cfif url.assetId eq "">
 <cfset url.assetid = CLIENT.assetid>
<cfelse>
	<cfset CLIENT.assetid = url.assetid>
</cfif>
<cfset url.assetid = replace(url.assetid,"'","","all")>

<cfquery name="SearchResult" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT     O.AssetId, 
             O.MovementId, 
			 O.Status, 						
			 O.DateEffective, 
			 L.LocationName,
			 M.MovementCategory, 
			 M.Reference, 
			 R.Description,
			 O.OfficerUserId,
			 O.OfficerLastName,
			 O.OfficerFirstName
  FROM       AssetItemLocation O 
	         INNER JOIN Location L ON O.Location = L.Location
			 INNER JOIN AssetMovement M ON O.MovementId = M.MovementId
			 INNER JOIN Ref_Movement R ON M.MovementCategory = R.Code
  WHERE      O.AssetId = '#URL.AssetId#' 			 
  ORDER BY   O.DateEffective DESC  
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
<tr><td class="labellarge" style="height:30px"><cf_tl id="Location History"></td></tr>
<tr class="labelmedium line">
	<td style="padding-left:10px"><cf_tl id="Effective"></td>
	<td><cf_tl id="Movement"></td>
	<td><cf_tl id="Location"></td>	
	<td><cf_tl id="Reference"></td>
	<td><cf_tl id="Status"></td>	
	<td><cf_tl id="Officer"></td>	
</tr>

<cfoutput query="Searchresult">
	<tr class="labelmedium line navigation_row">
	<td style="padding-left:10px">#DateFormat(DateEffective, CLIENT.DateFormatShow)#</td>
	<td>#Description#</td>			
	<td>#LocationName#</td>	
	<td>#Reference#</td>
	<td><cfif Status eq "1"><cf_tl id="Confirmed"><cfelse><cf_tl id="Pending"></cfif></td>
	<td>#OfficerLastName#</td>
	</tr>
</cfoutput>
</table>

<cfset ajaxonLoad("doHighlight")>