resource "aws_route53_record" "munkireport_box" {
  zone_id = "Z2VP0FHJ6U7I35"
  name    = "munkireport-demo.grahamgilbert.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.munkireport_instance.public_ip}"]
}
