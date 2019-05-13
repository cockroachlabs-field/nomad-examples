job "crdb" {
  datacenters = ["dc1"]

  update {
    max_parallel = 1
    healthy_deadline = "3m"
  }

  group "master-group" {
    count = 1

    ephemeral_disk {
      migrate = true
      size = 1500
      sticky = true
    }

    task "start-master" {
      driver = "raw_exec"
      leader = true

      artifact {
        source = "https://binaries.cockroachdb.com/cockroach-v19.1.0.darwin-10.9-amd64.tgz"
      }

      config {
        command = "local/cockroach-v19.1.0.darwin-10.9-amd64/cockroach"
        args = [
          "start",
          "--insecure",
          "--store", "node-master-${NOMAD_ALLOC_INDEX}",
          "--host", "${NOMAD_IP_tcp}",
          "--port", "${NOMAD_PORT_tcp}",
          "--http-port", "${NOMAD_PORT_http}"
        ]
      }

      resources {
        cpu = 500
        memory = 1000
        network {
          port "http" {}
          port "tcp" {
            static = "26257"
          }
        }
      }

      service {
        name = "master"
        port = "tcp"
        check {
          name = "master-http-check"
          type = "tcp"
          port = "http"
          interval = "10s"
          timeout = "1s"
        }
        check {
          name = "master-tcp-check"
          type = "tcp"
          port = "tcp"
          interval = "10s"
          timeout = "1s"
        }
      }
    }
  }

  group "node-group" {
    count = 2

    ephemeral_disk {
      migrate = true
      size = 1500
      sticky = true
    }

    task "start-node" {
      driver = "raw_exec"
      leader = true

      artifact {
        source = "https://binaries.cockroachdb.com/cockroach-v19.1.0.darwin-10.9-amd64.tgz"
      }

      config {
        command = "local/cockroach-v19.1.0.darwin-10.9-amd64/cockroach"
        args = [
          "start",
          "--insecure",
          "--store", "node-${NOMAD_ALLOC_INDEX}",
          "--host", "${NOMAD_IP_tcp}",
          "--port", "${NOMAD_PORT_tcp}",
          "--http-port", "${NOMAD_PORT_http}",
          "--join", "127.0.0.1:26257"
        ]
      }

      resources {
        cpu = 500
        memory = 1000
        network {
          port "http" {}
          port "tcp" {}
        }
      }

      service {
        name = "node"
        port = "tcp"
        check {
          name = "node-http-check"
          type = "tcp"
          port = "http"
          interval = "10s"
          timeout = "1s"
        }
        check {
          name = "node-tcp-check"
          type = "tcp"
          port = "tcp"
          interval = "10s"
          timeout = "1s"
        }
      }
    }
  }
}