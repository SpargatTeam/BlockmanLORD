const NavBar = [
    { text: 'Home', link: '/' },
    { text: 'About', link: '/about/' },
    { text: 'Docs', link: '/docs/' },
    {
        text: 'GitHub',
        link: 'https://github.com/blockmanlord',
        target: '_blank'
    }
];
const SideBar = {
    '/docs/': [
        {
            title: 'Docs',
            collapsable: false,
            children: [
                '/docs/lua',
                '/docs/game'
            ]
        }
    ]
};
module.exports = {
    NavBar,
    SideBar
};  