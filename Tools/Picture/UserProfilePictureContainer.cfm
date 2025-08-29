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
<!--- this tag should be placed at the root level of the DOM
meaning:  on the body level --->

<style>
	#__ProsisPresentation_widmodalbg {
		z-index:11;
		background-color:#454545;
		opacity:0.3;
		filter:alpha(opacity=30);
		width:100%;
		height:100%;
		position:absolute;
		display:none;
		}	
		
	#__ProsisPresentation_picturedialog {
		position:absolute;
		display:none;
		width:500px;
		height:360px;
		top:50%;
		left:50%;
		margin-left:-250px;
		margin-top:-200px;
		border:1px solid white;
		background-color:#f3f3f3;
		z-index:700;
		overflow:hidden;
		-webkit-border-radius: 10px;
		-moz-border-radius: 10px;
		border-radius: 10px;
		-webkit-box-shadow:  1px 1px 10px 2px #6c6c6c;
	    -moz-box-shadow:  1px 1px 10px 2px #6c6c6c;
	    box-shadow:  1px 1px 10px 2px #6c6c6c;
		-webkit-transition: all 800ms ease-in-out;
		-moz-transition: all 800ms ease-in-out;
		-o-transition: all 800ms ease-in-out;
		-ms-transition: all 800ms ease-in-out;
		transition: all 800ms ease-in-out;
	}
</style>

<!---Hidden dialog until Photo is clicked --->
<div id="__ProsisPresentation_picturedialog"></div>	
<div id="__ProsisPresentation_widmodalbg"></div>		