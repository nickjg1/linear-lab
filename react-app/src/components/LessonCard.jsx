import { Card, CardContent, CardMedia, Typography } from '@mui/material';
import { Link } from 'react-router-dom';

const LessonCard = ({ title, image, content }) => {
	return (
		<Card
			sx={{
				width: { xs: '100%', sm: '358px', md: '320px' },
				boxShadow: 'none',
				borderRadius: 0,
			}}
		>
			<Link to={`/lesson/${title}`}>
				<CardMedia
					image={image}
					alt={title}
					sx={{
						width: {
							xs: '100%',
							sm: '358px',
							md: '320px',
						},
						height: 180,
					}}
				/>
			</Link>
			<CardContent sx={{ backgroundColor: '#1e1e1e', height: '106px' }}>
				<Link to={`/lesson/${title}`}>
					<Typography variant="subtitle1" fontWeight="bold" color="#FFF">
						{title}
					</Typography>
				</Link>
			</CardContent>
		</Card>
	);
};

export default LessonCard;
