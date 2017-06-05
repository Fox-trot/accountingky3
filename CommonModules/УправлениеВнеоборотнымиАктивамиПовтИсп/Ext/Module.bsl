﻿// Функция получает данные из справочника "СпособыОтраженияРасходовПоАмортизации".
//
// Параметры:
//   СпособыОтраженияРасходовПоАмортизации - СправочникСсылка.СпособыОтраженияРасходовПоАмортизации - ссылка на справочник.
//
// Возвращаемое значение:
//  ТаблицаЗначений - данные из табличной части справочника. 
//
Функция СпособыОтраженияРасходовПоАмортизации(СпособОтраженияРасходовПоАмортизации) Экспорт

	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СпособыОтраженияРасходовПоАмортизацииСпособы.СчетЗатрат,
		|	СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто1,
		|	СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто2,
		|	СпособыОтраженияРасходовПоАмортизацииСпособы.Субконто3,
		|	СпособыОтраженияРасходовПоАмортизацииСпособы.Коэффициент
		|ИЗ
		|	Справочник.СпособыОтраженияРасходовПоАмортизации.Способы КАК СпособыОтраженияРасходовПоАмортизацииСпособы
		|ГДЕ
		|	СпособыОтраженияРасходовПоАмортизацииСпособы.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", СпособОтраженияРасходовПоАмортизации);
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции // ПолучитьСпособОтраженияРасходовПоАмортизации()
