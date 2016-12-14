$ sudo apt-get install guile-1.8 guile-1.8-dev guile-1.8-doc doxygen
$ cd /tmp
$ wget http://rudeserver.com/cgiparser/download/rudecgi-5.0.0.tar.gz
$ tar zxf rudecgi-5.0.0.tar.gz
$ pushd rudecgi-5.0.0; ./configure; sudo make && make install; popd
$ git clone git@github.com:Spicery/ginger.git
$ cd ginger 
$ APPGINGER=`pwd`
$ ./configure
$ sudo make && make install
$ cd examples
$ common2gnx hello.cmn
