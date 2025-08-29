<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="Attributes.ItemNo" default="">
<cfparam name="Attributes.Active" default="Yes">

<!DOCTYPE HTML>
<html>
<head>
	<title>Photo Tag demo</title>
	<style type="text/css">
		
		div.photo-column {
			float: left ; 
			margin-right: 10px ;
		}
		
		div.photo-container {
			border: 0px solid #333333 ;
			margin-bottom: 13px ;
		}
		
	</style>
	<cf_screentop jquery="Yes" html="no">
	
	<cfoutput>	
	<script type="text/javascript" src="#client.root#/tools/tagger/coldfusion.json.js"></script>
	<script type="text/javascript" src="#client.root#/tools/tagger/phototagger.jquery.js"></script>
	</cfoutput>
	<cfif attributes.active eq "Yes">
		<cfoutput>	
		<script type="text/javascript">
			
			var _current;
			var _current_text;		
			var _current_value;
			var vRoot = '#client.root#';
					
			jQuery(function( $ ){
				
				$( "div.photo-container" ).photoTagger({
					
					loadURL: "#client.root#/tools/tagger/LoadTags.cfm",
					saveURL: "#client.root#/tools/tagger/SaveTag.cfm",
					deleteURL: "#client.root#/tools/tagger/DeleteTag.cfm",
					cleanAJAXResponse: cleanColdFusionJSONResponse
				});
	
				$( "div.photo-container" ).photoTagger( "enableTagCreation" );
				
			});
			
		</script>
		</cfoutput>
	</cfif>	
</head>


<body>

	<div class="photo-column">

		<cfquery name="qItems" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 I.ItemNo,I.Mission,I.ImageClass,I.ImagePath,C.ResolutionHeight,C.ResolutionWidth
			FROM ItemImage I INNER JOIN Ref_ImageClass C
			ON I.ImageClass = C.Code
			WHERE I.ImageClass='Slider'
			AND I.ItemNo = '#Attributes.ItemNo#'
			ORDER BY I.Created DESC
		</cfquery>		

		<cfset SESSION.PhotoId = qItems.ItemNo > 
		<div class="photo-container">
			<cfoutput>
			<img 
				id="#qItems.ItemNo#" 
				src="#SESSION.rootdocument#/#qItems.ImagePath#" 
				width="#qItems.ResolutionWidth*0.4#"
				height="#qItems.ResolutionHeight*0.4#"
				/>
			</cfoutput>

							
		</div>


		<cfquery name="qItemsAll" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT I.ItemNo,I.ItemDescription
			FROM Item I
			ORDER BY I.ItemDescription ASC
		</cfquery>
	
	</div>
	
	<div id="dselection" style="position:absolute;width:200px;display:none">
		<select id="multiselect" multiple="multiple" style="width:300px">
			<cfoutput>
			<cfloop query="qItemsAll">
		    	<option value="#ItemNo#">#ItemNo# #ItemDescription#</option>
		    </cfloop>
		    </cfoutput>	
		</select>
	</div>	

	

</body>
<cfif attributes.active eq "Yes">
	<script>
		$("#multiselect").kendoMultiSelect({
			placeholder: "Select item...",
		    change: function(e) {
			    
			    var dataItem = this.dataItems();
			    var value = this.value();
			    
			    var element = '';
			    if (dataItem)
			    	element = dataItem[0].text;
			    
			    if (element!='')
			    {
			    	_current_text = element;
			    	_current_value = value;
					_current.photoTagger("doSave");
				}		    
			}		
		});
		
		
	</script>
</cfif>
</html>


