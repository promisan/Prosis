/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
		
	config.skin = 'moono-lisa';
		
	// Toolbar configuration generated automatically by the editor based on config.toolbarGroups.
	config.toolbar = [
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline','FontSize','TextColor','NumberedList', 'BulletedList' ] },
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

