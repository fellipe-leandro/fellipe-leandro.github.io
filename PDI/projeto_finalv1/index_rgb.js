	/**
	 * Simple example Node.js application to demonstrate face detection.
	 */

	/**
	 * Define the dependencies
	 */
	var express   =   require( 'express' )
	  , http       =    require( 'http' )
	  , async     =    require( 'async' )
	  , multer    =   require( 'multer' )
	  , upload     =    multer( { dest: 'uploads/' } )
	  , exphbs    =   require( 'express-handlebars' )
	  , easyimg   =    require( 'easyimage' )
	  , _         =    require( 'lodash' )
	  , cv         =   require( 'opencv' );

	/**
	 * Create a simple hash of MIME types to file extensions
	 */
	var exts = {
	  'image/jpeg'   :   '.jpg',
	  'image/png'    :   '.png',
	  'image/gif'    :   '.gif'
	}

	/**
	 * Note that you may want to change this, depending on your setup.
	 */
	var port = 8080;

	/**
	 * Create the express app
	 */
	var app = express();

	/**
	 * Set up the public directory
	 */
	app.use(express.static(__dirname + '/public'))

	/**
	 * Set up Handlebars templating
	 */
	app.engine('.hbs', exphbs( { extname: '.hbs', defaultLayout: 'default' } ) );
	app.set( 'view engine', '.hbs' );

	/**
	 * Default page; simply renders a file upload form
	 */
	app.get('/', function( req, res, next ) {

	  return res.render('index');

	});

	/**
	 * POST callback for the file upload form. This is where the magic happens.
	 */
	app.post('/upload', upload.array('file',2), function(req, res, next){
		console.log(req.files)

	  // Generate a filename; just use the one generated for us, plus the appropriate extension
	  var filename = req.files[1].filename + exts[req.files[1].mimetype]
	    // and source and destination filepaths
	    , src0 = __dirname + '/' + req.files[1].path
	    , dst0 = __dirname + '/public/images/' + filename;
	    

	    var filename2 = req.files[0].filename + exts[req.files[0].mimetype]
	    // and source and destination filepaths
	    , src1 = __dirname + '/' + req.files[0].path
	    , dst1 = __dirname + '/public/images/' + filename2;
	    console.log(filename);
	    console.log(filename2);



	  
	  /**
	   * Go through the various steps
	   */
	  async.waterfall(
	    [
	      function( callback ) {

	        /**
	         * Check the mimetype to ensure the uploaded file is an image
	         */
	        if (!_.contains(
	          [
	            'image/jpeg',
	            'image/png',
	            'image/gif'
	          ],
	          req.files[0].mimetype
	        ) ) {

	          return callback( new Error( 'Invalid file1 - please upload an image (.jpg, .png, .gif).' ) )

	        }

	        return callback();

	        /**
	         * Check the mimetype to ensure the uploaded file is an image
	         */
	        if (!_.contains(
	          [
	            'image/jpeg',
	            'image/png',
	            'image/gif'
	          ],
	          req.files[1].mimetype
	        ) ) {

	          return callback( new Error( 'Invalid file2 - please upload an image (.jpg, .png, .gif).' ) )

	        }

	        return callback();

	      },
	      // function( callback ) {

	      //   /**
	      //    * Get some information about the uploaded file
	      //    */
	      //   easyimg.info( src0 ).then(

	      //     function(file) {

	      //       /**
	      //        * Check that the image is suitably large
	      //        */
	      //       if ( ( file.width < 300 ) || ( file.height < 50 ) ) {

	      //         return callback( new Error( 'Image1 must be at least 640 x 300 pixels' ) );

	      //       }

	      //       return callback();
	      //     }
	      //   );
	      //   easyimg.info( src1 ).then(

	      //     function(file) {

	      //       /**
	      //        * Check that the image is suitably large
	      //        */
	      //       if ( ( file.width < 300) || ( file.height < 50 ) ) {

	      //         return callback( new Error( 'Image2 must be at least 640 x 300 pixels' ) );

	      //       }

	      //       return callback();
	      //     }
	      //   );
	      // },
	      // function( callback ) {

	      //   /**
	      //    * Resize the image to a sensible size
	      //    */
	      //   easyimg.resize(
	      //     {
	      //       width      :   960,
	      //       src        :   src,
	      //       dst        :   dst
	      //     }
	      //   ).then(function(image) {

	      //     return callback();

	      //   });

	      // },
	      function( callback ) {

	        /**
	         * Use OpenCV to read the (resized) image

	         */
	        cv.readImage( src0, function (err,	im) {
	        	cv.readImage(src1,function(err1,im1){
	        	    width=im.width();
	        		height=im.height();
	        		im1.resize(width,height);
	        		newImg= new cv.Matrix(height,width);

	        		//newImg= new cv.Matrix(im.height(),im.width());
	        		//im.cvtColor("CV_BGR2GRAY");
	        		//im1.cvtColor("CV_BGR2GRAY");

	        		var aux1=im1.toArray();
	        		var aux2=im1.type();

	        		
	        		var arrFinal=cv.Matrix.fromArray(aux1,aux2).toArray();

	        		//console.log('dimensao arrFinal');

	        		//img_gray=new cv.Matrix(im.height(),im.width())
	        		var valor1;
	        		var valor2;
	        		var MSBytes;
	        		var LSBytes;
	        		img_gray = im.copy();
	        		//console.log(img_gray.type());

	        		//var chanIm0=im.split()[0];
	        		//var chanIm1=im1.split()[0];
	        		var intIm0Matrix=new cv.Matrix();
	        		var intIm1Matrix=new cv.Matrix();
	        		im.convertTo(intIm0Matrix,cv.Constants.CV_8UC3);
	        		im1.convertTo(intIm1Matrix,cv.Constants.CV_8UC3);
	        		//intIm0Matrix.cvtColor("CV_BGR2GRAY");
	        		//intIm1Matrix.cvtColor("CV_BGR2GRAY");
	        		var arr0 =intIm0Matrix.toArray();
	        		var arr1 =intIm1Matrix.toArray();
	        		console.log(arr0[0]);
	        		console.log(arr0[0][0].length);
	        		console.log(arr0);
	        		console.log(arr1)
	        		//console.log(arr0.length);
	        		//console.log(a[2][2]);
	        		//console.log(a[2][2]<<1);
	        		//var d= c+b;
	        		//console.log(a[2][2]);
	        		//console.log(a[3][3]);
	        		//console.log(d);
	        		//intInputMatrix.get(1,1);

	        		//console.log(im1.get(5,3));
	        		for(var i=0; i<arr0.length;i=i+1){
	        			for(var j=0; j<arr0[i].length;j=j+1){
	        				for(var k=0;k<arr0[i][j].length;k=k+1){
	        				//valor1=im.get(i,j);
	        				//valor2=im1.get(i,j);
	        				valor1=arr0[i][j][k];
	        				valor2=arr1[i][j][k];
	        				MSBytes=valor1&0xF8;
	        				//console.log('Antes');
	        				//console.log(valor2);
	        				//console.log('Depois');
	        				//console.log(MSBytes);
	        				LSBytes=valor2&0xE0; //selecionar os 3 MS bits e zerar os 5 LS bit
	        				//console.log('Antes')
	        				//console.log(valor1);
	        				//console.log('Depois')
	        				//console.log(MSBytes);
	        				arrFinal[i][j][k]=(MSBytes|(LSBytes>>5)); //criando três canais devido a chamada da função
	        														  //from Array que se seguirá	
	        				//arrFinal[i][j][1]=(MSBytes|(LSBytes>>5));
	        				//arrFinal[i][j][2]=(MSBytes|(LSBytes>>5));
	        				//console.log(arrFinal[i][j])


	        			     }
	        			}
	        		}
	        		console.log(arrFinal.length);
	        		console.log(arrFinal[0].length);
	        		console.log(arrFinal[0][0].length);

                    //var matFinal=new cv.Matrix();
                    //arrFinal.convertTo(matFinal,cv.Constants.CV_8UC3);
	        		var matFinal=cv.Matrix.fromArray(arrFinal,cv.Constants.CV_8UC3);
	        		//matFinal.cvtColor("CV_BGR2GRAY");
	        		matFinal.save('public/final.png');

				});

	        });
	        

          },

	    ]); //fim do waterfall 
		      return res.render(
	        'result',
	        {

	        });


	});
	app.post('/uploadSplit', upload.single('fileToSplit'), function(req, res, next){
    var inputImg = req.file.filename + exts[req.file.mimetype]
    // nd source and destination filepaths
    , src = __dirname + '/' + req.file.path
    , dst = __dirname + '/public/images/' + inputImg;
    console.log(inputImg);
    cv.readImage(src, function (err,inputIm) {

	                var width = inputIm.width();
	                var height = inputIm.height();
	                if (width < 1 || height < 1) throw new Error('Image has no size');
	                //inputIm.save('mais_olha.pgm');

	        		 //var inputChan1=inputIm.split()[0]; //selecionar um unico canal
	        		 //console.log(inputChan1);
	        		 var intInputMatrix= new cv.Matrix();  //matriz de inteiros
	        		 inputIm.convertTo(intInputMatrix,cv.Constants.CV_8UC3); //converte matriz de entrada para matriz
	        		 														  //matriz de inteiros com 1  canal 
	        		 var arrIn=intInputMatrix.toArray(); 	//converte matriz para array. 
	        		 //console.log(arrIn[0][0]);//debug

	        		var inputAux1=inputIm.toArray(); //
	        	    var inputAux2=inputIm.type();
	        		var arrMain=cv.Matrix.fromArray(inputAux1,inputAux2).toArray(); //arrays que serao preenchidos
	        																		//para compor as duas imagens
	        		var arrHide=cv.Matrix.fromArray(inputAux1,inputAux2).toArray();
	        		 for (var i=0; i<arrIn.length;i++){
	        		 	for(var j=0;j<arrIn[i].length;j++){
	        		 		for(var k=0;k<arrIn[i][j].length;k=k+1){
	        		 			arrMain[i][j][k] = arrIn[i][j][k]&0xF8;
	        		 			arrHide[i][j][k]=(arrIn[i][j][k]&0x07)<<5;
	        		 			//arrMain[i][j][1] = arrIn[i][j]&0xF8;
	        		 			//arrHide[i][j][1]=(arrIn[i][j]&0x07)<<5;
								//arrMain[i][j][2] = arrIn[i][j]&0xF8;
	        		 			//arrHide[i][j][2]=(arrIn[i][j]&0x07)<<5;
	        		 		}


	        		 	}
	        		 }
	        		 console.log(arrHide.length);
	        		 console.log(arrHide[0].length);
	        		 console.log(arrHide[0][0].length);

	        		 var matMain=cv.Matrix.fromArray(arrMain,cv.Constants.CV_8UC3);
	        		 //matMain.cvtColor("CV_BGR2GRAY");
	        		 matMain.save('public/Main.jpg')
	        		 var matHide=cv.Matrix.fromArray(arrHide,cv.Constants.CV_8UC3);
	        		 //matHide.cvtColor("CV_BGR2GRAY");
	        		 matHide.save('public/Hide.jpg')

	        		 
	        		 });
    return res.render(
    	'split',
    {


    });
    


});

	/**
	 * Start the server
	 */
	http.createServer(
	  app
	).listen( port, function( server ) {
	  console.log( 'Listening on port %d', port );
	});
