<!--
    Copyright © 2025 Promisan

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
<cfparam name="Attributes.type" default="CK">	
<cfparam name="Attributes.mode" default="full">

<cfswitch expression="#Attributes.type#">

	<cfcase value="CK">
						
		<cfoutput>
			
			<script type="text/javascript" src="#SESSION.root#/Scripts/TextArea/CK/#Attributes.mode#/ckeditor.js"></script>
			<script type="text/javascript" src="#SESSION.root#/Scripts/TextArea/CK/#Attributes.mode#/styles.js"></script>


			<script>


				var _calculated_width_ = '100%';

				function removeTextAreaBorder()
				{
					$('.cke_chrome').css({"border":"0px"});
					$('.cke_bottom').css({"display":"none"});
				}
				
				function updateTextArea() {
		              $(".ckeditor").each(function(index) {
                     		CKEDITOR.instances[this.id].updateElement();
              		});
					
					$("div[contenteditable='true']").each(function(index) {
						data = 	CKEDITOR.instances[this.id].getData();
						document.getElementById(this.id+'_inline').value = data;
					});						
				}
								
				function destroyTextAreas()
				{
					for(name in CKEDITOR.instances)
					{
						CKEDITOR.instances[name].destroy();
					}					
				}

				function textAreaFit(s,perc)
				{
					var p=perc.replace('%','');
					var r = p*s/100;
					var h = $(document).height();
					console.log('s:'+s+'perc:'+perc+'r:'+r+'h:'+h+'\n');
					return r;
				}

				
				function getFunctionName(fun)
				{
					var ret = fun.toString();
					ret = ret.substr(0, ret.indexOf('('));
					return ret;					
					
				}

				function getParameters(fun)
				{
					var ret = fun.toString();
					ret = ret.substr(ret.indexOf('(')+1,ret.indexOf(')')-ret.indexOf('(')-1);
					ret2 = ret.replace(/\'/g, "")
					console.log('parameters:'+ret2);
					
					return ret2.split(",");					
					
				}

				function setEditorConfiguration(myeditor,id,_calculated_width_,_calculated_height_)
				{
					
						if (document.getElementById(id+'_onchange').value!="")
						{
							myeditor.config.extraPlugins = 'save';																			
					    	myeditor.on('change',function (evt){
						    	updateTextArea();
					    		vScript = document.getElementById(id+'_onchange').value
								vFunction   = getFunctionName(vScript);
								vParameters = getParameters(vScript);
								console.log(vFunction);
								console.log(vParameters);
								var fn = window[vFunction];
								if (typeof fn === "function") fn.apply(null, vParameters);
								return false;
							});
						}	 
																		
						myeditor.config.height             = document.getElementById(id+'_height').value
						myeditor.config.width              = document.getElementById(id+'_width').value
						
					    var allowedContent = document.getElementById(id+'_allowedContent').value;
					    console.log('allowedContent:'+allowedContent);
						

						if (allowedContent == 'yes')
						{
							myeditor.config.allowedContent = true;
							console.log(myeditor.config)
							console.log(myeditor);
							
							
													
						}
						
					   	if (document.getElementById(id+'_height').value.indexOf('%') == -1) {
					   		myeditor.config.resize_enabled = document.getElementById(id+'_resize').value;
					   	}
						else
						{
					   		myeditor.config.resize_enabled = true;
							myeditor.config.height = _calculated_height_;					   		
							myeditor.config.width  = _calculated_width_;							
						}
						
						if (document.getElementById(id+'_resize').value == 'false') {																				 						
							myeditor.config.resize_enabled = false 
						} else {
							myeditor.config.resize_enabled = true
						}						 
							
						if (document.getElementById(id+'_collapse').value == 'false') {															 
							myeditor.config.toolbarCanCollapse = false 						
						} else {
							myeditor.config.toolbarCanCollapse = true
						}				
						
						if (document.getElementById(id+'_color').value != '') {
								myeditor.setUiColor(document.getElementById(id+'_color').value);
						}
						else
						{
							myeditor.config.skin = document.getElementById(id+'_skin').value;
						}
						
											
							   					   																										
				}

				function initTextArea()	{
					
										
					$("div[contenteditable='true']" ).each(function( index ) {
				       CKEDITOR.disableAutoInline = true;

					   if (document.getElementById(this.id+'_toolbar').value.toLowerCase()=="full") {
					   		if (document.getElementById(this.id+'_expand').value.toLowerCase()=="no")	
						   		var myeditor = CKEDITOR.inline(this.id, {
									customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_config_ne.js'
								} );
							else
						   		var myeditor = CKEDITOR.inline(this.id, {
									customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_config.js'
								} );							
					   }
					   else if (document.getElementById(this.id+'_toolbar').value.toLowerCase()=="mini")
						{


								if (document.getElementById(this.id+'_expand').value.toLowerCase()=="no")
									var myeditor = CKEDITOR.inline(this.id, {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_mini_config_ne.js'
									} );
								else
									var myeditor = CKEDITOR.inline(this.id, {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_mini_config.js'
									} );
						}
					   else
					   {
					   		if (document.getElementById(this.id+'_expand').value.toLowerCase()=="no")
								var myeditor = CKEDITOR.inline(this.id, {
									customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_basic_config_ne.js'
								});
							else
								var myeditor = CKEDITOR.inline(this.id, {
									customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_basic_config.js'
								});												   
						}
						

						_calculated_height_ = textAreaFit(document.getElementById(this.name+'_pheight').value,document.getElementById(this.name+'_height').value);
						setEditorConfiguration(myeditor,this.id,_calculated_width_,_calculated_height_);
						
					});	

	
					$(".ckeditor").each(function(index) {		
						try{							
						   
						   if (document.getElementById(this.id+'_toolbar').value.toLowerCase()=="full") {
								if (document.getElementById(this.id+'_expand').value.toLowerCase()=="no")
							   		var myeditor = CKEDITOR.replace(this.id, {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_config_ne.js'
									} );
								else
							   		var myeditor = CKEDITOR.replace(this.id, {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_config.js'
									} );
								
						   }
							else if (document.getElementById(this.id+'_toolbar').value.toLowerCase()=="mini")
							{
									if (document.getElementById(this.id+'_expand').value.toLowerCase()=="no")
									var myeditor = CKEDITOR.replace(this.id, {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_mini_config_ne.js'
									} );
									else
									var myeditor = CKEDITOR.replace(this.id, {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_mini_config.js'
									} );
						   }
						   else {
						   		if (document.getElementById(this.id+'_expand').value.toLowerCase()=="no")
									var myeditor = CKEDITOR.replace(this.id, {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_basic_config_ne.js'
									});
								else
									var myeditor = CKEDITOR.replace(this.id, {
										customConfig: '#SESSION.root#/Scripts/TextArea/CK/prosis_basic_config.js'
									});
													   
							}
							
							var ID = this.id; 
							if (document.getElementById(ID+'_onkeyup').value!="") {
								 
							 	CKEDITOR.instances[ID].on('change', function(event) {
							 			CKEDITOR.instances[ID].updateElement();
							 			console.log(event.editor.getData()); 
							 			
						 				var str = document.getElementById(ID+'_onkeyup').value;
   								 		var F   = new Function(str);
										F();
       								 
    						 	});
    						}
							
							
							_calculated_height_ = textAreaFit(document.getElementById(this.name+'_pheight').value,document.getElementById(this.name+'_height').value);
							setEditorConfiguration(myeditor,this.id,_calculated_width_,_calculated_height_);							
						
  						} catch(e) {
  							console.log(e)
							
  						}		
					});		
													
				}
				
				function setEditor()
				{
					
					CKEDITOR.replace( 'editor1' );
				}

				function toggleReadOnly(id,isReadOnly) {
					var veditor = CKEDITOR.instances[id];
					veditor.setReadOnly(isReadOnly);
				}
				
			</script>			
		</cfoutput>
				
	</cfcase>
		
</cfswitch>


