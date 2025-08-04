/*
 * Copyright © 2025 Promisan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
CKEDITOR.editorConfig = function( config ) {
		
	config.skin = 'moono-lisa';
		
	// Toolbar configuration generated automatically by the editor based on config.toolbarGroups.
	config.toolbar = [
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Underline','FontSize','TextColor','Table','NumberedList', 'BulletedList' ] },
		{ name: 'tools', items: [ 'Maximize' ] }
	];

	// Set the most common block elements.
	config.format_tags = 'p;h1;h2;h3;pre';
	
	config.isContentHeight = true;
	
};

CKEDITOR.on( 'instanceReady', function ( ev ) {
		var editor = ev.editor;
		removeTextAreaBorder();
		editor.on( 'blur', function( evt ) {         
			editor.updateElement();
	    } );
} ); 

