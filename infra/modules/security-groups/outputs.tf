output "bastion_sg_id" { value = aws_security_group.bastion.id }
output "front_sg_id"   { value = aws_security_group.front.id }
output "alb_sg_id"     { value = aws_security_group.alb.id }
output "back_sg_id"    { value = aws_security_group.back.id }
output "db_sg_id"      { value = aws_security_group.db.id }