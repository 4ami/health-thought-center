import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config();
class AuthHelper {
    static generateToken(user) { return jwt.sign({_id: user._id, role: user.role}, process.env.TOKEN_KEY, {expiresIn: '7m'}); }
    static generateRefreshToken(user) { return jwt.sign({_id: user._id, role: user.role}, process.env.REFRESH_KEY, { expiresIn: '7d' } ); }
    static verifyRefreshToken(token) {  
        const verify = jwt.verify(token, process.env.REFRESH_KEY);
        return jwt.sign({_id: verify._id, role: verify.role}, process.env.TOKEN_KEY, {expiresIn: '7m'});
    }
}

export default AuthHelper;