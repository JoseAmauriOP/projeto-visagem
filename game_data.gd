class_name GameData

const LEGENDS = {
	"amortalhado": {
		"name": "O Amortalhado",
		"features": ["lua_cheia", "morte", "vulto", "religioso"],
		"story": "Lenda da Serra da Ibiapaba, contada em Tianguá e Ubajara. Um homem que desrespeitou os pais foi condenado a carregar um morto nas costas por cemitérios, em sete noites de lua cheia. Quem zomba dele pode herdar a maldição.",
		"profile": "Na Serra da Ibiapaba, contam de um homem condenado a vagar por cemitérios carregando um morto nas costas. Só cumpre sua penitência em noites de lua cheia, rezando o rosário em silêncio. Quem cruza com ele na estrada vê um vulto curvado e sente que a morte passou perto.",
	},
	"goiabao": {
		"name": "O Goiabão",
		"features": ["arvore", "vulto", "religioso"],
		"story": "Causo de Missão Velha, no Cariri. O espírito de um religioso aparecia gigante, sentado no muro do antigo ginásio, perto do pé de goiaba onde teria morrido. Dizem que sumiu quando a árvore foi cortada.",
		"profile": "Em Missão Velha, no Cariri, o espírito de um antigo religioso aparece gigante, sentado num muro, com uma perna em cada rua. Dizem que está preso ao pé de goiaba onde gostava de ficar. Não faz barulho nenhum e não escolhe noite: só observa, quieto, quem passa por baixo.",
	},
	"isaura": {
		"name": "Isaura",
		"features": ["lua_cheia", "som", "animais", "arvore"],
		"story": "Lenda da Lagoa do Urubu, em Fortaleza. Os moradores contam que uma cobra gigante vive na lagoa, faz sumir os animais da beira d'água e ronca nas noites de lua cheia.",
		"profile": "Na Lagoa do Urubu, em Fortaleza, vive uma cobra gigante que ninguém consegue ver direito. Os animais que pastam na beira d'água somem sem deixar rastro, e nas noites de lua cheia se ouve o seu ronco vindo da lagoa. Dizem que ela se enrosca nos coqueiros da margem.",
	},
	"rasga_mortalha": {
		"name": "Rasga-mortalha",
		"features": ["som", "morte", "vulto"],
		"story": "Crença espalhada por todo o Ceará: o grito dessa coruja, parecido com pano rasgando, anunciaria uma morte. Na verdade, é a suindara, uma ave inofensiva que controla ratos e ainda é perseguida por causa do mito.",
		"profile": "Em todo o Ceará se conhece o grito da rasga-mortalha: um som de pano sendo rasgado em cima do telhado. Quem vê o vulto branco passando baixo no escuro já sabe que é agouro de morte para algum doente da casa. Os bichos do terreiro nem se mexem quando ela passa.",
	},
	"fulozinha": {
		"name": "Comadre Fulozinha",
		"features": ["som", "animais", "arvore"],
		"story": "Protetora da mata no folclore nordestino. Trança a crina dos cavalos em nós que ninguém desfaz e engana caçadores com seu assobio. Quem leva mingau, fumo ou mel ganha a simpatia dela.",
		"profile": "Protetora das matas do Nordeste, a Comadre Fulozinha vive entre as árvores e trança a crina dos cavalos em nós que ninguém desfaz. Seu assobio engana: parece longe quando está perto. É muito difícil vê-la, e ela não liga para a lua, porque anda em qualquer noite escura.",
	},
}

const LOCATIONS = {
	"rezadeira": {
		"name": "Casa da rezadeira",
		"feature": "lua_cheia",
		"found": [
			"Só nas noites de lua cheia, algo se aproxima da casa.",
			"A rezadeira jura: é sempre sob a lua cheia que a coisa se manifesta.",
		],
		"nothing": [
			"Luar ou não, a noite passa quieta por aqui.",
			"Nenhum sinal, mesmo com a lua cheia no céu.",
		],
	},
	"janela": {
		"name": "Janela do quarto",
		"feature": "som",
		"found": [
			"Um som estranho ecoa lá fora, vindo do breu.",
			"Algo faz barulho na escuridão, impossível dizer o quê.",
		],
		"nothing": [
			"A noite passa em silêncio absoluto.",
			"Nenhum som além do vento nas árvores.",
		],
	},
	"curral": {
		"name": "Curral",
		"feature": "animais",
		"found": [
			"O gado se agita sem motivo, olhos fixos no escuro.",
			"Os animais estão inquietos, como se sentissem algo por perto.",
		],
		"nothing": [
			"Os bichos dormem tranquilos, sem sinal de perturbação.",
			"Nada incomoda os animais esta noite.",
		],
	},
	"enfermo": {
		"name": "Casa do enfermo",
		"feature": "morte",
		"found": [
			"Um mau agouro paira sobre a casa do doente.",
			"Algo ronda a casa, como se esperasse por um fim.",
		],
		"nothing": [
			"Nenhum mau presságio paira sobre a casa esta noite.",
			"A casa segue em paz, sem sinal de agouro.",
		],
	},
	"mata": {
		"name": "Beira da mata",
		"feature": "arvore",
		"found": [
			"Uma árvore ali parece guardar algo, ou alguém.",
			"Há sinais estranhos ao redor de uma árvore, na beira da mata.",
		],
		"nothing": [
			"As árvores da beira da mata não escondem nada de anormal.",
			"Nenhuma árvore por ali parece fora do comum.",
		],
	},
	"estrada": {
		"name": "Estrada da vila",
		"feature": "vulto",
		"found": [
			"Moradores juram ter visto um vulto na estrada, à noite.",
			"Uma sombra atravessou o caminho, ninguém soube dizer o que era.",
		],
		"nothing": [
			"A estrada segue vazia, sem vultos ou sombras à vista.",
			"Nenhum vulto foi visto por ali esta noite.",
		],
	},
	"capela": {
		"name": "Capela",
		"feature": "religioso",
		"found": [
			"Há algo na capela ligado ao sagrado, ou ao que restou dele.",
			"Um clima estranho toma conta da capela, como se algo sagrado tivesse sido perturbado.",
		],
		"nothing": [
			"A capela permanece em paz, sem qualquer presença estranha.",
			"Nada perturba a capela esta noite.",
		],
	},
}

const CASES = {
	"barateiro": {
		"title": "Caso 1: Vila Barateiro",
		"playable": true,
		"intro": "Você é investigador de visagens, chamado sempre que o sertão perde o sossego.\n\nDesta vez, o recado veio da Vila Barateiro. Há dias os moradores não dormem direito. Cada um conta uma história diferente, e ninguém concorda sobre o que anda assombrando o lugar.\n\nVocê tem três noites para descobrir qual visagem está na vila, antes que o medo faça o povo ir embora.",
		"locations": ["rezadeira", "janela", "curral", "enfermo", "mata", "estrada", "capela"],
		"suspects": ["amortalhado", "goiabao", "isaura", "rasga_mortalha", "fulozinha"],
	},
	"alto_cruzeiro": {
		"title": "Caso 2: Alto do Cruzeiro",
		"playable": false,
	},
}
