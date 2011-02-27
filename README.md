Stapler
=======

Stapler uses YUI Compressor to automatically compress cached assets in Rails


Features/Problems
-----------------

* Support both CSS and Javascript


Requirements
------------

* yuicompressor gem

TODO
------------

* warnings if the bundle URL is longer than 2048 chars (for IE)
* make sure that Config.secret is not a class variable
* logging
* specs
* pass 404 errors to the underlying app

Install
-------

* gem install stapler


References
----------

  * YUI Compressor - <http://developer.yahoo.com/yui/compressor/>
  * yuicompressor gem - <http://github.com/mjijackson/yuicompressor>


Author
------

Michael Rykov :: missingfeature.com :: @michaelrykov


License
-------

(The MIT License)

Copyright (c) 2009  Michael Rykov

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
