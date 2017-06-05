﻿
&НаКлиенте
Процедура Подбор(Команда)
	ОткрытьФорму("Справочник.КлассификаторОтраслевойПринадлежностиНИ.Форма.ФормаПодбораИзКлассификатора",, ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	КлассификаторXML = Справочники.КлассификаторОтраслевойПринадлежностиНИ.ПолучитьМакет("ОтраслевыеКоэффициенты").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	Для Каждого ЗаписьОКВ Из КлассификаторТаблица Цикл
	
		Назначение	= ЗаписьОКВ.Branch;
		Коэффициент	= ЗаписьОКВ.Coeficient;
				
		ЗаписатьЭлементСправочника(Назначение, Коэффициент);     	
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Вопрос = "Справочник будет перезаполнен! Продолжить?";
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект), Вопрос, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, );
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ  = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьНаСервере();  
	
	Элементы.Список.Обновить();

КонецПроцедуры

// Записывает текущиц элемент классификатор с учетом
// иерархии 
&НаСервере  
Функция ЗаписатьЭлементСправочника(Назначение, Коэффициент)	
	НайденнаяСсылка =  Справочники.КлассификаторОтраслевойПринадлежностиНИ.НайтиПоНаименованию(Назначение);
	Если НайденнаяСсылка.Пустая() Тогда
		Объект = Справочники.КлассификаторОтраслевойПринадлежностиНИ.СоздатьЭлемент();
		Объект.Наименование = Назначение;
		Объект.Коэффициент  = Коэффициент;
	Иначе
		Объект = НайденнаяСсылка.ПолучитьОбъект();
	КонецЕсли;	
	
	Объект.Наименование = Назначение;
	
	Попытка
		Объект.Записать();
	Исключение
		Сообщить("Не удалось записать элемент: " + Назначение + " "+  Коэффициент  + Символы.ПС + ОписаниеОшибки(), СтатусСообщения.Важное);
	КонецПопытки;
		
	Возврат Объект.Ссылка;
КонецФункции // ЗаписатьЭлементСправочника  


&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	Элементы.Список.Обновить();
	Элементы.Список.ТекущаяСтрока = РезультатВыбора;
КонецПроцедуры

