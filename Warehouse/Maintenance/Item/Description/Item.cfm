
<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *,
			(SELECT Description FROM Ref_Category WHERE Category = I.Category) as CategoryDescription
	FROM    Item I
	WHERE   ItemNo = '#URL.ItemNo#'
</cfquery>

<cfform method="POST" name="item" onsubmit="return false">

<table align="center">

	<tr>
		<TD style="padding-top:4px;padding-left:5px"><cf_tl id="Description">:<font color="FF0000">*</font></TD>
	</tr>

	<TR class="labelmedium2">
		    
		    <TD style="padding-left:0px">
			
			<cf_LanguageInput
					TableCode       = "Item" 
					Mode            = "Edit"
					Name            = "ItemDescription"
					Type            = "Input"
					Required        = "No"
					Value           = "#Item.ItemDescription#"
					Key1Value       = "#Item.ItemNo#"
					Message         = "Please enter a description"
					MaxLength       = "200"
					Size            = "80"
					Class           = "regularxl">
				
		    </TD>
	</TR>	
	
	<cfoutput>
	<tr>	
	  <td align="center" style="padding-top:13px">
	  <input type="button" name="Submit" value="Save" class="button10g" style="width:200px" onclick="itemapply('#url.context#','#url.id#','#url.box#','#URL.ItemNo#','#URL.UoM#')">
	   </td>	
	</tr>
	</cfoutput>
				

</table>

</cfform>

