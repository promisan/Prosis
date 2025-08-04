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
<cfparam name="attributes.id" 		default = "dpresenter">
<cfparam name="attributes.details" 	default = "">
<cfparam name="attributes.style" 	default = "">
<cfparam name="attributes.width" 	default = "">
<cfparam name="attributes.height" 	default = "">
<cfparam name="attributes.skin" 	default = ""> <!--- it can be also 'light', 'mac'--->
<cfparam name="attributes.bgcolor" 	default = ""> 
<cfparam name="attributes.opacity" 	default = "0.5"> 
<cfparam name="attributes.slideshow" 	default = "">  <!--- it is a number in millisenconds if present the slideshow starts ---->

<cfparam name="attributes.shadowblur" 		default = ""> <!--- it is a number 1, 2, 3 .... --->
<cfparam name="attributes.shadowcolor" 		default = "##54718e"> 
<cfparam name="attributes.shadowopacity" 	default = "0.5"> 
<cfparam name="attributes.src" 	default = ""> 


<cfif thisTag.ExecutionMode is 'start'>
		<cfoutput>
		<cfsavecontent variable="vScript">
						function open_#attributes.id#()
						{
						
							<cfif attributes.src neq "">
								var str = document.getElementById('__lists_#attributes.id#').innerHTML;
								var str = str.replace(/\amp;/g,'');
							<cfelse>	 
								var str = document.getElementById('__lists_#attributes.id#').value;
							</cfif>
							
							
									
							
							var arr = str.split(',');
							console.log(arr);

							var arr_2 = [];
							
							for (i=0;i<=arr.length;i++)
							{
								var json = arr[i];
								
								if (json)
								{
									var json= json.replace(/\+/g,',');
									var obj = jQuery.parseJSON(json);
									if (obj)
										arr_2.push(obj);
								}		
									
								
							}
							
							console.log(arr_2);		
																			
							if (arr_2.length>0 && str!='') 
							{
								Lightview.show(arr_2,
								{ 	
									viewport: 'scale',
									autoSize: true,
									controls: 'thumbnails',
									afterUpdate: function(element,position){ Lightview.refresh(); }
									<cfif attributes.width neq "">
										,width:#attributes.width# 
									</cfif>
									<cfif attributes.height	neq "">
										,height:#attributes.height#  
									</cfif>
									<cfif attributes.skin neq "">
										,skin: '#attributes.skin#' 
									</cfif>	
									<cfif attributes.bgcolor neq "">
										,background: { color: '#attributes.bgcolor#', opacity: #attributes.opacity# } 
									</cfif>
									<cfif attributes.shadowblur neq "">
										,shadow: {  blur: #attributes.shadowblur#,  color: '#attributes.shadowcolor#',  opacity: #attributes.shadowopacity#} 
									</cfif>
									<cfif attributes.slideshow neq "">
										,slideshow: #attributes.slideshow#
									</cfif>
									
									} );
									
								Lightview.refresh();
								<cfif attributes.slideshow neq "">
									Lightview.play();
								</cfif>					
							  }
							  else
							  	alert('No details found');		
						}
						
						callback_#attributes.id# = function(){
      							open_#attributes.id#();
					    } 
						
						error_#attributes.id# = function(){
      						alert('Cannot complete your request');
					    } 						
					
						<cfif attributes.src neq "">
							ColdFusion.navigate('#attributes.src#','__lists_#attributes.id#',callback_#attributes.id#,error_#attributes.id#)
						<cfelse>

							open_#attributes.id#();
						</cfif>		

		</cfsavecontent>

		<div onclick="#vScript#" class="itemline" style="#attributes.style# cursor: pointer;">
		</cfoutput>	

<cfelseif thisTag.ExecutionMode is 'end'>

		
		 <cfoutput>
			 <cfif attributes.src neq "">
				 <div id="__lists_#attributes.id#" name="__lists_#attributes.id#" style="display:none;"></div>
			 <cfelse>	 
				 <input type="hidden" id="__lists_#attributes.id#" name="__lists_#attributes.id#" value="#attributes.details#">
			 </cfif>
		 </cfoutput>
		 
		</div>
</cfif>		
		 