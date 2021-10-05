cd ~/itkmitl-bookinfo-details/src/details || git clone -b dev git@github.com:angellllegna/itkmitl-bookinfo-details.git ~/itkmitl-bookinfo-details/src/details
docker build -t details ~/itkmitl-bookinfo-details/src/details/
docker run -d --name details -p 8081:8081 details

cd ~/itkmitl-bookinfo-ratings/src/ratings || git clone -b dev git@github.com:angellllegna/itkmitl-bookinfo-ratings.git ~/itkmitl-bookinfo-ratings/src/ratings
docker build -t ratings ~/itkmitl-bookinfo-ratings/src/ratings/
docker run -d --name mongodb -p 27017:27017 -v  ~/itkmitl-bookinfo-ratings/src/ratings/databases:/docker-entrypoint-initdb.d bitnami/mongodb:5.0.2-debian-10-r2
docker run -d --name ratings -p 8080:8080 --link mongodb:mongodb -e SERVICE_VERSION=v2 -e 'MONGO_DB_URL=mongodb://mongodb:27017/ratings' ratings

cd ~/itkmitl-bookinfo-reviews/src/reviews || git clone -b dev git@github.com:angellllegna/itkmitl-bookinfo-reviews.git ~/itkmitl-bookinfo-reviews/src/reviews
docker build -t reviews ~/itkmitl-bookinfo-reviews/src/reviews/
docker run -d --name reviews -p 8082:8082 --link ratings:ratings -e ENABLE_RATINGS=true -e STAR_COLOR=salmon -e RATINGS_SERVICE=http://ratings:8080 reviews

cd ~/itkmitl-bookinfo-productpage/src/productpage || git clone -b dev git@github.com:angellllegna/itkmitl-bookinfo-productpage.git ~/itkmitl-bookinfo-productpage/src/productpage
docker build -t productpage ~/itkmitl-bookinfo-productpage/src/productpage/
docker run -d --name productpage -p 8083:8083 --link details:details -e DETAILS_HOSTNAME=http://details:8081 --link reviews:reviews -e REVIEWS_HOSTNAME=http://reviews:8082 --link ratings:ratings -e RATINGS_HOSTNAME=http://ratings:8080 productpage



