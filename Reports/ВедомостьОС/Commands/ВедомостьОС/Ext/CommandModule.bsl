﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	//Вариант = Новый Структура;
	//Вариант.Вставить("ИмяОтчета",    "ВедомостьПоАмортизацииОС");
	//Вариант.Вставить("КлючВарианта", "ВедомостьПоАмортизацииОС");
	//
	//БухгалтерскиеОтчетыКлиент.ОткрытьВариантОтчета(Вариант);
	ПараметрыФормы = Новый Структура("", );
	ОткрытьФорму("Отчет.ВедомостьОС.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
