create database if not exists videos;

use videos;

#Creamos dimension date
create table video_metadata(
    video_id varchar(11) primary key,
    title TinyText,
    description TEXT
);

#Creamos tabla de videos
create table video_data(
    video_id varchar(11) primary key,
    etag varchar(27),
    id varchar(48),
    published_date datetime
);

select * from video_data;

alter table video_metadata
add constraint fk_video_data foreign key (video_id)
references video_data(video_id);

#Creamos tabla de estadisticas
create table video_stats(
    video_id varchar(11) primary key,
    viewCount MediumInt,
    likeCount MediumInt,
    dislikeCount MediumInt,
    favoriteCount MediumInt,
    commentCount MediumInt
);

select * from video_stats;

alter table video_stats
add constraint fk_video_data_stats foreign key (video_id)
references video_data(video_id);


select m.*, v.published_date, s.viewCount, s.likeCount, s.dislikeCount, s.favoriteCount, s.commentCount
from video_metadata m join video_data v on m.video_id=v.video_id
join video_stats s on m.video_id = s.video_id;

select count(m.video_id)
from video_metadata m join video_data v on m.video_id=v.video_id
join video_stats s on m.video_id = s.video_id;


select count(*) from video_stats;







