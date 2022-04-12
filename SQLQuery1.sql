--create database Db_Leonard998
--use Db_Leonard998


--Exercicio 1
/*
1) Desenvolva uma procedure em PL/SQL que faça a verificação na tabela
aluno
se o mesmo está aprovado (maior igual a 7), recuperação (maior que 4 e
menor
que 7) e reprovado (menor que 4). Crie a tabela com os seguintes campos
código, nome, nota1, nota2, coddis, mensalidade, qtdefalta)
*/

create table aluno
( codigo int primary key,
 nome varchar(50),
 nota1 numeric(5,2),
 nota2 numeric(5,2),
 coddis int,
 mensalidade numeric(10,2),
 qtdefalta int
)
insert into aluno values (1,'Pedro Geromel',8,7,1,500,4)
insert into aluno values (2,'Diego Souza',5,7,2,400,2)
insert into aluno values (3,'Lucas Silva',2,3,3,400,8)
insert into aluno values (4,'Brenno',7,8,2,500,4)
select * from aluno
create table disciplina
( codigo int primary key,
 nome varchar(50),
 cargaho int
)
insert into disciplina values (1,'Matematica',80)
insert into disciplina values (2,'Banco de dados',80)
insert into disciplina values (3,'Programacao',80)
create procedure sp_media
@codigo int
as
declare @media numeric(5,2)
SET @media = (select (nota1+nota2)/2 from aluno where codigo = @codigo)
if @media >= 7
begin
 select 'Aprovado Média = '+ convert(char(5),@media)
end
else if @media < 4
 begin
 select 'Reprovado Media = '+ convert(char(5),@media)
 end
else
begin
 select 'Recuperação Media = '+ convert(char(5),@media)
end

EXEC sp_media 1

/*
2 Crie uma procedure em PL/SQL para inserir um aluno na tabela apenas se a
quantidade de alunos for menor que 10 senão apresentar a quantidade e
mensagem turma lotada.
*/
create procedure sp_qtde
as
declare @qtde int
set @qtde = (SELECT COUNT(*) FROM ALUNO)
if @qtde < 10
begin
 insert into aluno values (5,'Thiago Santos',3,4,2,700,5)
end
else
begin
 select 'Turma Lotada ' + convert(char(5),@qtde)
end

exec sp_qtde
select * from aluno

/*
3) Faça uma procedure em PL/SQL que apresente a quantidade de
alunos aprovados, em recuperação e reprovados.
*/
create procedure sp_alunos
as
declare @apr int
declare @rep int
declare @rec int
set @apr = (select count(*) from aluno where (nota1+nota2)/2 >=7)
set @rep = (select count(*) from aluno where (nota1+nota2)/2 < 4)
set @rec = (select count(*) from aluno where (nota1+nota2)/2 >= 4 and
(nota1+nota2)/2 < 7)
If @apr >= 1
begin
 Select 'Qtde de Aprovados '+ convert(char(5),@apr)
end
If @rep >= 1
begin
 Select 'Qtde de Reprovados '+ convert(char(5),@rep)
end
If @rec >= 1
begin
 Select 'Qtde de Recuperação '+ convert(char(5),@rec)
end

exec sp_alunos

/*
4) Crie a tabela disciplina (código, nome, cargaho) e
relacione com a tabela aluno
e insira os dados na tabela disciplina e no campo da tabela aluno e elabore
uma
procedure em PL/SQL que apresente os seguintes valores:
a) Para a disciplina Matemática mensalidade mais 10%
b) Para Banco de dados mensalidade menos 20 %
c) Para Programação mensalidade mais 15%
*/
create procedure sp_disciplina
@disci int
as
if @disci = 1 --matematica
begin
select a.nome,d.nome,a.mensalidade*1.1 as 'Mensalidade mais 10%'
from aluno a
inner join disciplina d
on a.coddis = d.codigo
where a.coddis = @disci
end
else if @disci = 2
begin
select a.nome,d.nome,a.mensalidade*0.8 as 'Mensalidade menos 20%'
from aluno a
inner join disciplina d
on a.coddis = d.codigo
where a.coddis = @disci
end
else if @disci = 3
begin
select a.nome,d.nome,a.mensalidade*1.15 as 'Mensalidade mais 15%'
from aluno a
inner join disciplina d
on a.coddis = d.codigo
where a.coddis = @disci
end

exec sp_disciplina 2

/*
5)Desenvolva uma procedure em PL/SQL que passe por parâmetro o código
do
aluno e se não encontrar mostrar a mensagem aluno não cadastrado, se
encontrar mostrar o nome a media e a disciplina cursada.
*/
create procedure sp_alu
@codigo int
as
declare @media numeric(5,2)
declare @disci varchar(40)
declare @nome varchar(40)
set @media = (select (nota1+nota2)/2 from aluno
 where codigo = @codigo)
set @nome = (select nome from aluno
 where codigo = @codigo)
set @disci = (select d.nome from aluno a
 inner join disciplina d
 on a.coddis = d.codigo
 where a.codigo = @codigo)
if @media > 0
begin
 select @nome
 select @disci
 select @media
end

exec sp_alu 2 

--Continuação STORED PROCEDURE.

--Exercicios do dia 31/03.


/*
1) Crie um stored procedure em PL/SQL que passe por parâmetro
o código da disciplina e mostre a qtde de alunos e a soma das
mensalidades.
*/

create procedure sp_soma
@coddis int
as
declare @qtde int
declare @soma numeric(10,2)
set @qtde = (select count(*) from aluno where coddis = @coddis )
set @soma = (select sum(mensalidade) from aluno where coddis = @coddis )
select ' A qtde de aluno da disciplina é '+convert(char(5),@qtde)
select ' A soma das mensalidades da disciplina é '+
convert(char(10),@soma)

exec sp_soma 2


/*
2) Elabore uma procedure em PL/SQL que passe por parâmetro um
código de aluno e verifique se está aprovado, recuperação ou
reprovado, também está reprovado de a qtde de faltas for maior 3.
*/

create procedure sp_sit_alu
@codalu int
as
declare @media numeric(5,2)
declare @qtdefalta int
set @media=(select (nota1+nota2)/2 from aluno where codigo =@codalu)
set @qtdefalta=(select qtdefalta from aluno where codigo =@codalu)
if @qtdefalta > 3
begin
Select 'Reprovado por Faltas'
end
else
begin
if @media >= 7
begin
select 'Aprovado'
end
else if @media < 4
begin
select 'Reprovado'
end
else
begin
Select 'Recuperação'
end
end

exec sp_sit_alu 5


/*
3) Desenvolva uma procedure em PL/SQL que passe por parâmetro
um código de aluno e atualize a mensalidade em 20% caso esteja
reprovado, 10% para recuperação e um desconto de 30% se aprovado.
*/

create procedure sp_atu_mensa
@codalu int
as
declare @media numeric(5,2)
set @media=(select (nota1+nota2)/2 from aluno where codigo=@codalu)
if @media >= 7
begin
update aluno set mensalidade = mensalidade * 0.7
where codigo = @codalu
end
else if @media < 4
begin
update aluno set mensalidade = mensalidade * 1.2
where codigo = @codalu
end
else
begin
update aluno set mensalidade = mensalidade * 1.1
where codigo = @codalu
end

exec sp_atu_mensa 2
select * from aluno


/*
4) Faça uma procedure em PL/SQL que receba por parâmetro
um código de aluno e atualize a mensalidade em percentual,
conforme a quantidade de faltas, ou seja, se 4 faltas aumentar
em 4% a mensalidade do aluno.
*/
create procedure sp_atu_me
@codalu int
as
declare @qtdefalta int
set @qtdefalta=(select qtdefalta from aluno where codigo = @codalu)
update aluno set mensalidade =
mensalidade + (mensalidade*@qtdefalta)/100
where codigo = @codalu

exec sp_atu_me 5
select * from aluno


/*
5) Elabore uma procedure em PL/SQL que verifique se o aluno
tem mensalidade maior que 500 se sim adicione um novo campo
email varchar(50) na tabela aluno e atualizar o email com
as 3 primeiras letras do nome mais @unicesumar.edu.br
*/

--alter table aluno add email varchar(50)
create procedure sp_email
@codalu int
as
declare @mensalidade numeric(10,2)
set @mensalidade=(select mensalidade from aluno where codigo =@codalu)
if @mensalidade > 500
begin
update aluno set email=substring(nome,1,3)+'@unicesumar.edu.br'
where codigo = @codalu
end
--execução
exec sp_email 5
select * from aluno
