module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        coffee: {
            compile: {
                options: {
                    join: true,
                    bare: true
                },
                files: {
                    'temp/minglezen-src.js': [ 'src/coffee/**/*.coffee' ]
                }
            }
        },
        concat: {
            vendor: {
                src: [
                    'src/vendor/*.js'
                ],
                dest: 'temp/minglezen-vendor.js'
            },
            dist: {
                src: [ 'temp/minglezen-vendor.js', 'temp/minglezen-src.js' ],
                dest: 'temp/minglezen.js'
            }
        },
        uglify: {
            options: {
                mangle: false
            },
            dist: {
                files: {
                    'build/minglezen.min.js': [ 'temp/minglezen.js' ]
                }
            }
        },
        clean: [ 'temp' ],
        stylus: {
            compile: {
                options: {
                    compress: true,
                    use: [ require('nib') ],
                    import: [ 'nib' ]
                },
                files: {
                    'build/minglezen.min.css': [ 'src/styl/*.styl' ]
                }
            }
        },
        watch: {
            coffee: {
                files: 'src/coffee/**/*.coffee',
                tasks: [ 'coffee' ],
                options: {
                    interrupt: true,
                    interval: 100
                }
            },
            stylus: {
                files: 'src/styl/*.styl',
                tasks: [ 'stylus' ],
                options: {
                    interrupt: true,
                    interval: 100
                }
            },
            concat: {
                files: 'src/*.js',
                tasks: [ 'concat', 'uglify', 'clean' ],
                options: {
                    interrupt: true,
                    interval: 100
                }
            }
        }
    });

    // Log when files are changed
    grunt.event.on('watch', function(action, filepath, target) {
        grunt.log.writeln(target + ': ' + filepath + ' has ' + action);
    });

    // Load the plugins that provide the tasks.
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-stylus');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-clean');

    // Default task(s).
    grunt.registerTask('default', [ 'coffee', 'stylus', 'concat', 'uglify', 'clean' ]);
    grunt.registerTask('w', [ 'default', 'watch' ]);

};
