all: setup run

setup:
	wget -O config.toml.old \
		'https://raw.github.com/tutumcloud/influxdb/master/0.10/config.toml'
	sed '/[opentsdb]/I,+1 d' ./config.toml.old >> config.toml 
	docker run -d -p 8083:8083 -p 8086:8086 -p 4242:4242 \
		-e PRE_CREATE_DB="influxdb" \
		-v config.toml:/config/config.toml \
		--name influxdb \
		tutum/influxdb
	docker run -d -p 3000:3000 \
		--link influxdb:influxdb \
                -e "AUTH_ANONYMOUS_ENABLE=true" \
                -e "AUTH_ANONYMOUS_ORG_ROLE=Admin" \
		-v metric.js:/usr/share/grafana/public/dashboards/metric.js \ 
		--name grafana \
		grafana/grafana
	curl 'http://admin:admin@127.0.0.1:3000/api/orgs/1' \
		-X PUT -i -H "Accept: application/json" \
		-d 'name="Main Org."'
	curl 'http://admin:admin@127.0.0.1:3000/api/datasources' \
		-X POST -H 'Content-Type: application/json;charset=UTF-8' \
		--data-binary '{"name":"SCADA","type":"influxdb_09","url":"http://127.0.0.1","access":"proxy","isDefault":true,"database":"influxdb","user":"admin","password":"admin"}' 

space := 
space += 

run:
	java -Dfile.encoding=UTF-8 \
		-classpath bin:$(subst  $(space),:,$(wildcard lib/*.jar)) \
		com.eclipse.scada.demo.hd.client.app.App &
	xdg-open 'http://localhost:3000/dashboard/script/metric.js?name=ES.DEMO.ARDUINO001.HUMIDITY.V&edit&panelId=1&fullscreen' &

clean:
	docker stop grafana influxdb
	docker-machine stop dev
