particlesJS("particles-js", {
            particles: {
                number: {
                    value: 48,
                    density: {
                        enable: !0,
                        value_area: 721.5354273894853
                    }
                },
                color: {
                    value: "#ffffff"
                },
                shape: {
                    type: "edge",
                    stroke: {
                        width: 0,
                        color: "#000000"
                    },
                    polygon: {
                        nb_sides: 11
                    },
                    image: {
                        src: "img/github.svg",
                        width: 100,
                        height: 100
                    }
                },
                opacity: {
                    value: .5,
                    random: !1,
                    anim: {
                        enable: !1,
                        speed: 1,
                        opacity_min: .1,
                        sync: !1
                    }
                },
                size: {
                    value: 8.017060304327615,
                    random: !0,
                    anim: {
                        enable: !1,
                        speed: 40,
                        size_min: .1,
                        sync: !1
                    }
                },
                line_linked: {
                    enable: !0,
                    distance: 150,
                    color: "#ffffff",
                    opacity: .4,
                    width: 1
                },
                move: {
                    enable: !0,
                    speed: 6,
                    direction: "none",
                    random: !1,
                    straight: !1,
                    out_mode: "out",
                    bounce: !1,
                    attract: {
                        enable: !1,
                        rotateX: 600,
                        rotateY: 1200
                    }
                }
            },
            interactivity: {
                detect_on: "canvas",
                events: {
                    onhover: {
                        enable: !0,
                        mode: "grab"
                    },
                    onclick: {
                        enable: !0,
                        mode: "repulse"
                    },
                    resize: !0
                },
                modes: {
                    grab: {
                        distance: 962.3114965770939,
                        line_linked: {
                            opacity: .19742849386737724
                        }
                    },
                    bubble: {
                        distance: 194.89853095232286,
                        size: 367.6323676323676,
                        duration: 3.654347455356053,
                        opacity: .4872463273808071,
                        speed: 3
                    },
                    repulse: {
                        distance: 200,
                        duration: .4
                    },
                    push: {
                        particles_nb: 4
                    },
                    remove: {
                        particles_nb: 2
                    }
                }
            },
            retina_detect: !0
        });