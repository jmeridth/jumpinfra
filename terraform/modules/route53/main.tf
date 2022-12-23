data "aws_route53_zone" "jumpco" {
  name = "jump.co."
}

resource "aws_route53_record" "dns" {
  zone_id = data.aws_route53_zone.jumpco.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

