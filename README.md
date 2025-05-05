> Ideia: A feira a amizade é um evento que acontece na Igreja Assembleia de Deus Beira Rio a varios anos, e como sou membro dessa igreja e queria contribuir com algo para o evento, eu decidi criar um menu digital com os alimentos vendidos na feira para facilitar a escolha do público. 
> Sobre a feira: A feira é um evento social com foco em arrecadação de fundos para o ministério social poder abençoar vidas.

# Menu Digital para a Feira da Amizade 2025
Esse foi um projeto bem desafiador, pois tive pouco tempo de desenvolvimento e tinha poucos conhecimentos de colocar projetos em produção. 

# Desafios enfrentados:
## 1º - HTML e CSS
Apesar de ter feito alguns cursos de HTML e CSS, eu nunca tive uma base de conhecimento sólida neles. Então eu fiz muitas gambiarras e coisas redundantes. Porém, o mais importante para esse projeto, ficou "bonito" e usual.

## 2º - Docker e Docker-compose 
Esse desafio foi um dos mais complicados, pois nunca cheguei a colocar um projeto em produção e criar uma imagem docker e orquestrar com o docker compose foi muito complicado. Mas gostei bastante dessa parte e achei incrível o funcionamento do docker (é gratificante ver tudo o que fiz em minha máquina funcionando em um servidor em nuvem).

## 3º - Hospedagem
Esse desafio aconteceu junto com o desafio do docker, pois como o projeto será usado em um cenário real, ele deve ser acessado de forma externa, seguro e confiável. A solução para esse problema veio a partir de uma palestra que ouvi sobre FinOps, onde o palestrante falou sobre a MagaluCloud. Usando a MagaluCloud eu consegui colocar o projeto no ar em poucos minutos e com muita facilidade.

## 4º - Processamento paralelo
Durante o desenvolvimento do Back-End eu usei o SQLite e já sabia que esse banco de dados não é o mais recomendado para um projeto em com processamento em paralelo, porém eu quis deixar para resolver isso por ultimo e isso foi um desafio enorme, pois tive que reescrever toda a lógica como o meu programa interagia com o banco de dados (além de passar uma dor de cabeça enorme).

# Melhorias que poderia ter feito
Planejo colocar essas melhorias em prática na próxima edição da feira da amizade.
 - ##  1º - Utilizar um ORM
    Utilizando um ORM todo o meu projeto ficaria mais fácil, mas eu não tenho uma base boa de conhecimento em nenhum ORM (ActiveRecords ou Squel).
 - ## 2º - Desfragmentação do projeto
    O meu projeto está funcionando como um grande monólito, o que não é nada flexivel e prático para colocar em produção (pensando em uma forma mais robusta de produção).
 - ## 3º - Produção com o Kubernetes
    Eu poderia ter utilizado o K8s, para colocar o meu projeto em produção, mas ainda não tenho uma base sólida para isso.

# Tecnologias utilizadas
 - Ruby 
  - Gem Sinatra (micro framework web)
  - Gem Puma (para colocar o sinatra em produção)
  - gem Rackup _(me fez passar muita dor de cabeça)_
 - Redis
 - Mysql/SQLite/PostgreSQL
 - Docker e docker-compose
 - Nginx


# Dados: 
![relatório](https://github.com/pedrorchagas/Menu-Digital/blob/main/images/users.png?raw=true)
Utilizei o Google Analytics para pegar algumas informações, como: Número de visitantes, tempo gasto, origem, etc.
Para um projeto grande esses números podem ser muito pequenos, mas considerando que tive menos de uma semana para desenvolver o sistema e colocar no ar. Ver esses números me encheu de grande alegria.

# Conclusão: 
Portanto, com esse projeto eu pude colocar a mão na massa e realmente testar e aprender sobre diversas tecnologias que estão em alta no mercado, além de poder contribuir na arrecadação de fundos para o ministério social da igreja. E pude sentir uma sensação muito gostosa, que é de ver as pessoas utilizando uma solução que eu desenvolvi. 
    

