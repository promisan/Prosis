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


