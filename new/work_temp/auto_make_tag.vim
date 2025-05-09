vim9script
# vim: set ts=8 sts=2 sw=2 tw=0 expandtab
scriptencoding utf-8


#----------------------------------------------------------------------------------------
# MakeTags
# Auto Make Tag
#----------------------------------------------------------------------------------------


com! MakeTags call MakeTags()


augroup MyVimrc_AutoMakeTag
  au!
  # TODO
  au BufWritePost *.c,*.h MakeTags
augroup end


function MakeTags()
  if exists('s:mk_tag_job')
    if job_status(s:mk_tag_job) == 'run'
      return
    endif
  endif

  if &fileencoding == 'cp932'
    let s:mk_tag_job = job_start('sh -c "git rev-parse --show-toplevel && cd `git rev-parse --show-toplevel` && ctags -Rf tags_tmp && sed -i -e' .. "'1i!_TAG_FILE_ENCODING	CP932'" .. ' tags_tmp && mv tags_tmp tags && awk ' .. "'{ print $1 }'" .. ' tags | sort | uniq > tag_only"')
  else # utf-8
    let s:mk_tag_job = job_start('sh -c "git rev-parse --show-toplevel && cd `git rev-parse --show-toplevel` && ctags -Rf tags_tmp &&                                                                mv tags_tmp tags && awk ' .. "'{ print $1 }'" .. ' tags | sort | uniq > tag_only"')
  endif
endfunction


# ( cd `git rev-parse --show-toplevel` && ctags -Rf tags_tmp && mv tags_tmp tags && \awk '{ print $1 }' tags > tag_only ) &

# ÅI”Å
# ( git rev-parse --show-toplevel && cd `git rev-parse --show-toplevel` && ctags -Rf tags_tmp && mv tags_tmp tags && awk '{ print $1 }' tags > tag_only ) &
# ( git rev-parse --show-toplevel && cd `git rev-parse --show-toplevel` && rm tags_tmp && ctags -Rf tags_tmp && sed -i -e'1i!_TAG_FILE_ENCODING	CP932' tags_tmp && mv tags_tmp tags && awk '{ print $1 }' tags > tag_only)
