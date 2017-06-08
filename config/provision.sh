#!/usr/bin/env bash

	#Change hostname to sgndev
	old=$(hostname)
	new="sgndev"
	for file in \
	   /etc/exim4/update-exim4.conf.conf \
	   /etc/printcap \
	   /etc/hostname \
	   /etc/hosts \
	   /etc/ssh/ssh_host_rsa_key.pub \
	   /etc/ssh/ssh_host_dsa_key.pub \
	   /etc/motd \
	   /etc/ssmtp/ssmtp.conf
	do
	   sudo [ -f $file ] && sudo sed -i.old -e "s:$old:$new:g" $file
	done
	sudo hostname sgndev


	#Update Aptitude
	sudo apt-get update -y
	sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
	sudo apt-get install -y gcc build-essential module-assistant

	#Install Emacs and gedit and vim
	sudo apt-get install -y emacs gedit vim less

	#Install htop
	sudo apt-get install htop -y

	#Install git
	sudo apt-get install git -y

	#Install linux headers for good measure
	sudo apt-get install -y dkms linux-headers-$(uname -r)

	#Install perl-docs
	sudo apt-get install perl-doc -y

	#Install memtester
	sudo apt-get install memtester -y

	#Install ack-grep
	sudo apt-get install ack-grep -y

	#make installer
	sudo apt-get install make xutils-dev -y

	#filezilla installer
	#sudo apt-get install filezilla -y

	#install mongodb
	#sudo apt-get install mongodb -y

	#Set root user password to vagrant

	yes vagrant | sudo passwd root

	#Set Superuser: vagrant user already NOPASSWD superuser

	#Install curl
	sudo apt-get install curl -y

	#Install cpanmin
	curl -L https://cpanmin.us | perl - --sudo App::cpanminus

	#Install Iceweasel
	sudo apt-get install iceweasel -y

	#Install libreoffice
	sudo apt-get install libreoffice -y

	#Install Docker
	sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install docker-ce -y
	
	#Install Nginx
	sudo apt-get install nginx -y

	#NMAP
	sudo apt-get install -y nmap

	#For headless selenium testing
	sudo apt-get install -y xvfb

	#NCBI Blast (legacy blastall)
	mkdir /home/vagrant/blast
	cd /home/vagrant/blast

	wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy/2.2.9/blast-2.2.9-amd64-linux.tar.gz
	tar zxvpf blast-2.2.9-amd64-linux.tar.gz
	sudo sed -i '$ a\export PATH="$PATH:/home/vagrant/blast/"' /home/vagrant/.bashrc
	rm blast-2.2.9-amd64-linux.tar.gz

	#sudo apt-get install ncbi-blast+ -y #latest relaese of BLAST

	#Install slurm
	sudo apt-get install libmunge-dev libmunge2 munge -y
	sudo apt-get install slurm-wlm slurmctld slurmd -y
	sudo apt-get install libslurm-perl -y
	#Copy slurm.conf from shared config folder to where it needs to go
	sudo touch /etc/slurm-llnl/slurm.conf
	sudo cat /vagrant/config/slurm.conf >> /etc/slurm-llnl/slurm.conf
	#sudo sh -c "cp /vagrant/config/slurm.conf /etc/slurm-lnll/ "

	sudo chmod 777 /var/spool/
	sudo mkdir /var/spool/slurmstate
	sudo chown slurm:slurm /var/spool/slurmstate/
	sudo /usr/sbin/create-munge-key
	sudo ln -s /var/lib/slurm-llnl /var/lib/slurm

	sudo systemctl enable slurmctld.service
	sudo systemctl start slurmctld.service
	sudo systemctl enable slurmd.service
	sudo systemctl start slurmd.service
	sudo systemctl enable munge.service
	sudo systemctl restart munge.service

	#Install graphviz
	sudo apt-get install graphviz -y

	#Install imagemagick
	sudo apt-get install imagemagick -y

	#Install barebones gnome GUI
	sudo apt-get install gnome-core -y
	sudo apt-get install gnome-terminal -y
	sudo apt-get install -y gnome-shell gnome-screensaver gnome-tweak-tool gnome-shell-extensions

	#Install full gnome (takes forever)
	# sudo apt-get install gnome -y

	#Permit any user to start the GUI
	sudo sed -i s/allowed_users=console/allowed_users=anybody/ /etc/X11/Xwrapper.config

	#Enable automatic gnome login for vagrant user
	sudo sed -i s/\#\ \ AutomaticLoginEnable\ =\ true/AutomaticLoginEnable\ =\ true/ /etc/gdm3/daemon.conf
	sudo sed -i s/\#\ \ AutomaticLogin\ =\ user1/AutomaticLogin\ =\ vagrant/ /etc/gdm3/daemon.conf
	#Start GNOME GUI
	sudo /etc/init.d/gdm3 start


	#Make and populate cxgn directory
	sudo mkdir /home/vagrant/cxgn
	cd /home/vagrant/cxgn
	git clone https://github.com/solgenomics/sgn.git
	git clone https://github.com/solgenomics/cxgn-corelibs.git
	git clone https://github.com/solgenomics/Phenome.git
	git clone https://github.com/solgenomics/biosource.git
	git clone https://github.com/solgenomics/Cview.git
	git clone https://github.com/solgenomics/ITAG.git
	git clone https://github.com/solgenomics/tomato_genome.git
	git clone https://github.com/GMOD/Chado.git
	git clone https://github.com/solgenomics/sgn-devtools.git
	git clone https://github.com/solgenomics/solGS.git
	git clone https://github.com/solgenomics/Barcode-Code128.git
	git clone https://github.com/solgenomics/Tea.git
	git clone https://github.com/solgenomics/art.git
	git clone https://github.com/solgenomics/VIGS.git
	git clone https://github.com/solgenomics/fixture.git
	git clone https://github.com/solgenomics/SGN_vagrant.git

	#Mason website skins
	git clone https://github.com/solgenomics/cassava.git
	git clone https://github.com/solgenomics/yambase.git
	git clone https://github.com/solgenomics/sweetpotatobase.git
	git clone https://github.com/solgenomics/ricebase.git
	git clone https://github.com/solgenomics/citrusgreening.git
	git clone https://github.com/solgenomics/coconut.git
	git clone https://github.com/solgenomics/cassbase.git
	git clone https://github.com/solgenomics/musabase.git
	git clone https://github.com/solgenomics/potatobase.git
	git clone https://github.com/solgenomics/cea.git


	#Install Perl Modules
	sudo cpanm install Catalyst::ScriptRunner
	sudo cpanm Catalyst::Restarter
	sudo cpanm HTML::Mason::Interp
	sudo cpanm Selenium::Remote::Driver
	sudo cpanm DBI
	sudo cpanm Hash::Merge
	sudo cpanm DBIx::Connector
	sudo cpanm Catalyst::Plugin::Authorization::Roles
	sudo cpanm Bio::PrimarySeq
	sudo cpanm Class::DBI
	sudo cpanm Tie::UrlEncoder
	sudo cpanm Data::BitMask
	sudo cpanm enum
	sudo cpanm File::NFSLock
	sudo cpanm Class::MethodMaker
	sudo cpanm Bio::BLAST::Database
	sudo cpanm Catalyst::Plugin::SmartURI
	sudo cpanm Modern::Perl
	sudo cpanm List::Compare
	sudo cpanm Cache::File
	sudo cpanm Config::JFDI
	sudo cpanm CatalystX::GlobalContext --force
	sudo cpanm DBIx::Class::Schema
	sudo cpanm Bio::Chado::Schema
	sudo cpanm Array::Utils
	sudo cpanm JSON::Any
	sudo cpanm Math::Round
	sudo cpanm Math::Round::Var
	sudo cpanm Catalyst::View::Email
	sudo cpanm Catalyst::View::HTML::Mason
	sudo cpanm Catalyst::View::Bio::SeqIO
	sudo cpanm Catalyst::View::JavaScript::Minifier::XS@2.101001
	sudo cpanm Catalyst::View::Download::CSV
	sudo cpanm URI::FromHash
	sudo cpanm JSAN::ServerSide
	sudo cpanm Config::INI::Reader
	sudo cpanm Bio::GFF3::LowLevel
	sudo cpanm Statistics::Descriptive
	sudo cpanm String::Random
	sudo cpanm MooseX::FollowPBP
	sudo apt-get install libgd2-xpm-dev -y
	sudo cpanm GD
	sudo cpanm Tie::Function
	sudo cpanm Digest::Crc32
	sudo cpanm Barcode::Code128
	sudo cpanm Math::Base36
	sudo cpanm Captcha::reCAPTCHA
	sudo cpanm Test::Aggregate::Nested --force
	sudo cpanm HTML::FormFu
	sudo cpanm SVG
	sudo cpanm IPC::Run3
	sudo cpanm Spreadsheet::WriteExcel
	sudo cpanm MooseX::Object::Pluggable
	sudo cpanm R::YapRI::Base
	sudo cpanm PDF::Create
	sudo cpanm String::CRC
	sudo cpanm Algorithm::Combinatorics
	sudo cpanm Catalyst::Controller::HTML::FormFu
	sudo cpanm String::Approx
	sudo apt-get install libcairo2-dev -y
	sudo cpanm Cairo
	sudo cpanm Chart::Clicker
	sudo cpanm Spreadsheet::ParseExcel
	sudo cpanm MooseX::Types::URI
	sudo cpanm Bio::Graphics::FeatureFile --force
	sudo cpanm Mail::Sendmail
	sudo cpanm Array::Compare
	sudo cpanm GD::Graph::lines
	sudo cpanm GD::Graph::Map
	sudo cpanm Bio::GMOD::GenericGenePage
	sudo cpanm Number::Bytes::Human
	sudo cpanm AnyEvent --force
	sudo cpanm IO::Event --force
	sudo cpanm File::Flock
	sudo cpanm Graph
	sudo cpanm Bio::SeqFeature::Annotated
	sudo cpanm XML::Twig
	sudo cpanm XML::Generator
	sudo apt-get install libpq-dev -y
	sudo cpanm DBD::Pg
	sudo cpanm MooseX::Runnable@0.09
	sudo cpanm XML::Feed
	sudo cpanm Parse::Deb::Control
	sudo cpanm Bio::GMOD::Blast::Graph
	sudo cpanm Catalyst::DispatchType::Regex
	sudo cpanm DateTime::Format::Flexible
	sudo cpanm DateTime::Format::Pg
	sudo cpanm HTML::TreeBuilder::XPath
	sudo cpanm JSON::XS
	sudo cpanm Lingua::EN::Inflect
	sudo cpanm List::AllUtils
	sudo cpanm MooseX::Declare
	sudo cpanm MooseX::Singleton
	sudo cpanm SOAP::Transport::HTTP
	sudo cpanm Test::Class
	sudo cpanm WWW::Mechanize::TreeBuilder
	sudo cpanm Data::UUID
	sudo cpanm HTML::Lint --force
	sudo cpanm Test::JSON
	sudo cpanm Test::MockObject
	sudo cpanm Test::WWW::Selenium
	sudo cpanm Sort::Versions
	sudo cpanm Term::ReadKey --force
	sudo cpanm Spreadsheet::Read
	sudo cpanm Sort::Maker
	sudo cpanm Term::Size::Any
	sudo cpanm Proc::ProcessTable
	sudo cpanm URI::Encode
	sudo cpanm Archive::Zip
	sudo cpanm Statistics::R
	sudo cpanm Lucy::Simple
	sudo cpanm DBIx::Class::Schema::Loader
	sudo cpanm Text::CSV
	sudo cpanm Imager::QRCode
	sudo cpanm GD::Barcode::QRcode
	sudo cpanm LWP::UserAgent
	sudo cpanm Set::Product

	#Extract perl libs from vagrant shared config folder. Contains all of the sudo cpanm install commands above.
	#sudo tar -xf /vagrant/config/perl_lib.tar.gz -C /  ##/usr/local/share/perl/5.20.2/
	#sudo tar -xf /vagrant/config/perl_local_lib.tar.gz -C /  ##/usr/local/lib/x86_64-linux-gnu/perl/5.20.2/

	sudo mkdir /export
	sudo mkdir /export/prod
	sudo mkdir /export/prod/public
	sudo mkdir /export/prod/public/sgn_static_content
	sudo mkdir /export/prod/tmp
	sudo mkdir /export/prod/tmp/solgs
	sudo mkdir /data
	sudo mkdir /data/prod
	sudo mkdir /data/prod/archive
	sudo mkdir /export/prod/public/images
	sudo mkdir /export/prod/public/images/image_files
	sudo mkdir /data/shared
	sudo mkdir /data/shared/tmp

	sudo chown -R vagrant:vagrant /data/prod/
	sudo chown -R vagrant:vagrant /export/prod/

	#Add sgn_local.conf to sgn directory, copied from shared config directory
	sudo cp /vagrant/config/sgn_local.conf /home/vagrant/cxgn/sgn
	sudo chown -R vagrant:vagrant /home/vagrant/cxgn/

	#Install postgres 9.4
	#sudo apt-get install postgresql-9.4 -y
	#sudo apt-get install postgresql-contrib-9.4 -y

	#Install postgres 9.5
	sudo su -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main 9.5' > /etc/apt/sources.list.d/postgresql.list"
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo apt-get update -y
	sudo apt-get install postgresql-9.5 -y

	#Configure trust connection for psql postgres user and create web_usr .
	sudo sed -i s/peer/trust/ /etc/postgresql/9.5/main/pg_hba.conf
	sudo /etc/init.d/postgresql restart
	#Create web_usr role with password web_usr
	yes web_usr | createuser -U postgres -P web_usr
	#Change postgres role password to postgres
	echo "ALTER ROLE postgres WITH PASSWORD 'postgres';" | psql -U postgres
	sudo /etc/init.d/postgresql restart

	#Create sandbox_cassava db and load dump from shared config folder.
	#sudo -u postgres createdb -E UTF8 --locale en_US.utf8 -T template0 sandbox_cassava
	#gunzip -c /vagrant/config/sandbox_cassava.pgsql.gz | sudo psql -U postgres sandbox_cassava

	#Create fixture db and load fixture.sql
	sudo -u postgres createdb -E UTF8 --locale en_US.utf8 -T template0 fixture
	sudo psql -U postgres -d fixture -f /home/vagrant/cxgn/fixture/cxgn_fixture.sql
	echo "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO web_usr;" | psql -U postgres -d fixture
	echo "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO web_usr;" | psql -U postgres -d fixture

	#Install R
	sudo apt-get install apt-transport-https -y
	sudo sed -i "\$adeb https://cran.cnr.berkeley.edu/bin/linux/debian jessie-cran3/" /etc/apt/sources.list
	sudo apt-key adv --keyserver keys.gnupg.net --recv-key 381BA480
	sudo apt-get update -y
	sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
	sudo apt-get install r-base r-base-dev -y
	#Better performance on linear algebra ops
	sudo apt-get install libatlas3-base -y
	sudo apt-get install libcurl4-openssl-dev -y --force-yes
	#Install R packages
	#qtl (>= 1.24-9), gplots (>= 2.10.1), ltm (>= 0.9-7), RColorBrewer (>= 1.0.5), rrBLUP (>= 3.8), plyr (>= 1.7.1), mail(>= 1.0), rjson(>= 0.2.12), agricolae (>= 1.2-1),  gtools (>= 2.6.2), gdata (>= 2.8.2), bitops (>= 1.0-4.1), caTools (>= 1.13), KernSmooth (>= 2.23-7), msm (>= 1.1.1), mvtnorm (>= 0.9.9992), polycor (>= 0.7-8), sfsmisc (>= 1.0-24), nlme (>= 3.1-103), irlba (>= 1.0.3), lme4 (>= 1.1-7), randomForest (>= 4.6-10), data.table (>= 1.9.6)
	sudo R -e "install.packages('qtl', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('randomForest', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('lme4', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('irlba', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('nlme', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('sfsmisc', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('polycor', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('mvtnorm', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('msm', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('KernSmooth', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('caTools', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('bitops', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('gdata', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('gtools', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('rjson', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('mail', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('plyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('rrBLUP', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('RColorBrewer', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('ltm', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('gplots', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('data.table', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('agricolae', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('d3heatmap', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('tidyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('ggplot2', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e "install.packages('devtools', dependencies=TRUE, repos='http://cran.rstudio.com/')"
	sudo R -e 'source("http://bioconductor.org/biocLite.R");biocLite("gdsfmt");biocLite("SNPRelate")'
	sudo R -e 'library("devtools");install_github("solgenomics/rPackages/genoDataFilter");install_github("solgenomics/rPackages/phenoAnalysis")'

	cd /home/vagrant/cxgn

	#Download selenium 2.53.0
	wget https://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.0.jar

	#Jbrowse Setup
	sudo cp /vagrant/config/sgn_forward /etc/nginx/sites-available/
	sudo rm /etc/nginx/sites-enabled/default
	sudo ln -s /etc/nginx/sites-available/sgn_forward /etc/nginx/sites-enabled/
	sudo /etc/init.d/nginx restart
	cd /var/www/
	sudo mkdir jbrowse
	cd jbrowse
	sudo curl -O http://jbrowse.org/releases/JBrowse-1.12.1.zip
	sudo unzip JBrowse-1.12.1.zip
	sudo rm JBrowse-1.12.1.zip
	cd JBrowse-1.12.1
	sudo ./setup.sh

	#Install Atom text editor and cleanup
	sudo apt-get install xdg-utils -y
	wget https://github.com/atom/atom/releases/download/v1.6.0/atom-amd64.deb
	sudo dpkg --install atom-amd64.deb
	sudo apt-get -f install -y
	rm atom-amd64.deb
	#Install Atom Plugins
	apm install minimap
    # configure indent settings
    sed -i 's/invisibles: {}/invisibles: {}\n\    showIndentGuide: true\n\    tabLength: 4\n\    tabType: "soft"/g' ~/.atom/config.cson


	#Install Chrome and cleanup
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg --install google-chrome-stable_current_amd64.deb
	sudo apt-get -f install -y
	rm google-chrome-stable_current_amd64.deb

	#Bashrc customization
	#Add git branch display
	sed -i s/#force_color_prompt=yes/force_color_prompt=yes/ /home/vagrant/.bashrc
	sed -i '$ a\parse_git_branch(){' /home/vagrant/.bashrc
	sed -i '$ a\git branch 2> /dev/null | sed -e \x27/^[^*]/d\x27 -e \x27s/* \\(.*\\)/(\\1)/\x27' /home/vagrant/.bashrc
	sed -i '$ a\}' /home/vagrant/.bashrc
	sed -i '$ a\if [ \x27$color_prompt\x27 = yes ]; then' /home/vagrant/.bashrc
	sed -i '$ a\PS1=\x27${debian_chroot:+($debian_chroot)}\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[01;31m\\]$(parse_git_branch)\\[\\033[00m\\]\\$ \x27' /home/vagrant/.bashrc
	sed -i '$ a\else' /home/vagrant/.bashrc
	sed -i '$ a\PS1=\x27${debian_chroot:+($debian_chroot)}\\u@\\h:\\w$(parse_git_branch)\\$ \x27' /home/vagrant/.bashrc
	sed -i '$ a\fi' /home/vagrant/.bashrc
	sed -i '$ a\unset color_prompt force_color_prompt' /home/vagrant/.bashrc

	#Add Perl paths
	sudo sed -i '$ a\export PERL5LIB="$PERL5LIB:/usr/local/lib/x86_64-linux-gnu/perl/5.20.2:/usr/local/share/perl/5.20.2:/home/vagrant/cxgn/sgn/lib:/home/vagrant/cxgn/cxgn-corelibs/lib:/home/vagrant/cxgn/Phenome/lib:/home/vagrant/cxgn/Cview/lib:/home/vagrant/cxgn/ITAG/lib:/home/vagrant/cxgn/biosource/lib:/home/vagrant/cxgn/tomato_genome/lib:/home/vagrant/cxgn/Barcode-Code128/lib:/home/vagrant/cxgn/solGS/lib:/home/vagrant/cxgn/Chado/chado/lib:/home/vagrant/cxgn/Tea/lib:/home/production/cxgn/Tea"' /home/vagrant/.bashrc
