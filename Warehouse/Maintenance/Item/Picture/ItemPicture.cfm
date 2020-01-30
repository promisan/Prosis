
<cf_filelibraryscript>
<cfajaximport tags="cfdiv,cfform">

<cf_screentop height="100%" scroll="No" html="No" jquery="yes">
<cf_PresenterScript>	

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Item
	WHERE  ItemNo = '#URL.ID#'
</cfquery>

<cfoutput>
	<script>
	
		<!--- Image class Drill down  --->
		function showClass(cl){
		
			se = document.getElementById("div_"+cl);
			
			if (se.className == "hide"){
				ColdFusion.navigate('ItemPictureDetail.cfm?ItemNo=#url.ID#&Mission=#Item.Mission#&class='+cl,"div_"+cl);
				se.className = "regular";
			}else{
				se.className = "hide";
			}
			
		}
		
		<cf_tl id="Please select a valid picture" var="vSelectPicture">
		
		<!--- validates form and shows the loader gif --->
		function submitForm(cls){
		
			b = document.getElementById("uploadedfile_"+cls);
			
			console.log(b.value);
			
			if (b.value.length == 0) {
				alert('#vSelectPicture#.');
				return false;
			}else{
				// validation for IE9 and below
				if (b.value.indexOf(".jpg") == -1 && b.value.indexOf(".png")==-1 && b.value.indexOf(".jpeg")==-1 && b.value.indexOf(".JPG")==-1 ){
					alert('#vSelectPicture#.');
					return false;
				}
			}
			
			b.className = "hide";
			
			l = document.getElementById("loader_"+cls);
			l.className = "";
				
			return true;
			
		}
		
	</script> 
</cfoutput>
 
<!--- This is to make images to line-break automatically depending on the screen resolution --->
<style type="text/css">
	 .imageShow{
	 	float:left;
	 }
</style>
 
<table width="94%" height="100%" cellspacing="0" cellpadding="0" align="center">

    <cfoutput>
	
		<cfquery name="Cls" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_ItemClass
			WHERE      Code = '#Item.ItemClass#'
		</cfquery>
		
		<tr><td height="5"></td></tr>
		<tr class="line">
			<td colspan="6">
				<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr>
				
				    <td height="20" class="labelit"><cf_tl id="Class">:</td>
                        <td style="padding-left:5px"><strong>#Cls.Description#</strong></td>
				   
				    <td style="padding-left:15px" height="20" class="labelit"><cf_tl id="Code">:</td>
				    <td style="padding-left:5px"><strong>#item.Classification#</strong></td>
					
				   	<td style="padding-left:15px" height="20" class="labelit"><cf_tl id="Description">:</td>
					<td style="padding-left:5px"><strong>#item.ItemDescription#</strong></td>
					
					</tr>
				</table>
			</td>
		</tr>	
			
		<tr><td height="1" colspan="6" class="line"></td></tr>
		
		<tr>
			<td width="100%" height="100%" colspan="6" align="left" valign="top">
				
				<cfquery name="ImageClass" 
						 datasource="AppsMaterials" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 	SELECT *
							FROM   Ref_ImageClass
				</cfquery>
			
			    <cf_divscroll height="100%">
		
					<table width="98%" align="center" >
					
						<cfloop query="ImageClass">
							<tr class="line">
								<td style="width:10px;padding-top:5px"><cf_img icon="expand" onclick="showClass('#code#')" toggle="yes"></td>
								<td class="labellarge" onclick="showClass('#code#')" style="font-size:22px;cursor:pointer;height:45px">
									#Description# -  <font size="2"><span class="labelit" style="color:gray">#ResolutionWidth# x #ResolutionHeight#</span>
								</td>
								<td align="right" class="labelit" style="color:gray">
									<cf_tl id="The system will automatically create a thumbnail with resolution">: #ResolutionWidthThumbnail# x #ResolutionHeightThumbnail#
								</td>
							</tr>							
							<tr>
								<td colspan="3" id="div_#code#" class="hide">
								</td>
							</tr>
						</cfloop>
						
					</table>
					
				</cf_divscroll>
			
			</td>
		</tr>
	
	</cfoutput>	

</table>
	